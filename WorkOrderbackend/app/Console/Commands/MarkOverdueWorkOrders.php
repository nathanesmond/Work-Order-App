<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\WorkOrder;
use Carbon\Carbon;
class MarkOverdueWorkOrders extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'workorders:mark-overdue';



    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Mark pending or in-progress work orders as overdue when due_at has passed';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $count = WorkOrder::whereIn('status', ['pending', 'in_progress'])
            ->where('due_at', '<', Carbon::now())
            ->update(['status' => 'overdue', 'overdue_at' => Carbon::now()]);

        $this->info("Marked {$count} work orders as overdue.");
    }
}
