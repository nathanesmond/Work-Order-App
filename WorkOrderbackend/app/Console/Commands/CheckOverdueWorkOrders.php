<?php
namespace App\Console\Commands;

use App\Models\WorkOrder;
use App\Models\User;
use App\Models\WorkOrderNotification;
use Illuminate\Console\Command;
use Kreait\Laravel\Firebase\Facades\Firebase;

class CheckOverdueWorkOrders extends Command
{
    protected $signature = 'workorders:check-overdue';
    protected $description = 'Mark overdue work orders and notify users';

    public function handle()
    {
        $overdueOrders = WorkOrder::where(function ($q) {
            $q->whereIn('status', ['on_request', 'in_progress', 'pending'])
                ->where('due_at', '<', now());
        })
            ->orWhere(function ($q) {
                $q->where('status', 'overdue')
                    ->where('due_at', '<', now());
            })
            ->with(['department', 'requester', 'engineer'])
            ->get();

        $this->info("Found {$overdueOrders->count()} overdue orders.");

        if ($overdueOrders->isEmpty()) {
            $this->info('No overdue orders found.');
            return;
        }

        // mark any not yet overdue
        foreach ($overdueOrders as $order) {
            if ($order->status !== 'overdue') {
                $order->status = 'overdue';
                $order->overdue_at = now();
                $order->save();
                $this->info("Marked WO #{$order->id} as overdue.");
            }
        }

        $messaging = Firebase::messaging();

        foreach ($overdueOrders as $order) {
            // build recipient list
            $recipients = User::whereIn('department_id', [1, 10, 11])
                ->orWhereHas('roles', function ($q) {
                    $q->whereIn('name', ['admin', 'superadmin']);
                })
                ->get();

            // add requester
            if ($order->requester) {
                $recipients = $recipients->push($order->requester)->unique('id');
            }

            // add assigned engineer
            if ($order->engineer) {
                $recipients = $recipients->push($order->engineer)->unique('id');
            }

            // create DB notifications
            foreach ($recipients as $recipient) {
                $alreadyNotified = WorkOrderNotification::where('work_order_id', $order->id)
                    ->where('user_id', $recipient->id)
                    ->exists();

                if ($alreadyNotified)
                    continue;

                WorkOrderNotification::create([
                    'user_id' => $recipient->id,
                    'work_order_id' => $order->id,
                    'type' => 'overdue',
                    'title' => 'Work Order Overdue',
                    'message' => "WO #{$order->id} \"{$order->title}\" from {$order->department?->name} is overdue.",
                    'is_read' => false,
                ]);

                $this->info("DB notification created for {$recipient->name} WO #{$order->id}");
            }

            // send FCM push to chief engineers, IT, GM
            $fcmRecipients = User::whereIn('department_id', [1, 10, 11])
                ->whereNotNull('fcm_token')
                ->get();

            foreach ($fcmRecipients as $recipient) {
                try {
                    $messaging->send([
                        'token' => $recipient->fcm_token,
                        'notification' => [
                            'title' => 'Work Order Overdue',
                            'body' => "WO #{$order->id} \"{$order->title}\" from {$order->department?->name} is overdue.",
                        ],
                        'data' => [
                            'work_order_id' => (string) $order->id,
                            'type' => 'overdue',
                        ],
                    ]);
                    $this->info("Push sent to {$recipient->name} for WO #{$order->id}");
                } catch (\Exception $e) {
                    $this->error("Failed: {$e->getMessage()}");
                }
            }
        }

        $this->info('Overdue check complete.');
    }
}