<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\WorkOrder;
use App\Models\User;
use App\Models\Comment;
use Illuminate\Testing\Fluent\Concerns\Has;

class WorkOrderController extends Controller
{


    private function applyFilters($query, Request $request)
    {
        if ($request->status && $request->status !== 'all') {
            $query->where('status', $request->status);
        }

        if ($request->search) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%$search%")
                    ->orWhere('description', 'like', "%$search%")
                    ->orWhereHas('requester', function ($q) use ($search) {
                        $q->where('name', 'like', "%$search%");

                    });
            });
        }

        if ($request->range) {
            switch ($request->range) {
                case 'days30':
                    $query->where('created_at', '>=', now()->subDays(30));
                    break;
                case 'weeks2':
                    $query->where('created_at', '>=', now()->subWeeks(2));
                    break;
                case 'week1':
                    $query->where('created_at', '>=', now()->subWeek());
                    break;
                case 'day1':
                    $query->where('created_at', '>=', now()->subDay());
                    break;
            }
        }

        return $query;
    }
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:200',
            'description' => 'required|string',
            'hours' => 'required|integer|min:1|max:720'
        ]);

        $user = auth()->user();

        $workOrder = WorkOrder::create([
            'title' => $request->title,
            'description' => $request->description,
            'requester_id' => auth()->id(),
            'department_id' => $user->department_id,
            'status' => 'on_request',
            'due_at' => now()->addHours($request->hours)
        ]);

        $workOrder->load([
            'department:id,name',
            'requester:id,name,username',
        ]);

        return response()->json($workOrder, 201);
    }


    public function index(Request $request)
    {
        $query = WorkOrder::query();
        $this->applyFilters($query, $request);

        return $query->with([
            'engineer:id,name',
            'department:id,name',
            'requester:id,name',
            'cancelledByUser.department:id,name',
            'comments.user'
        ])->latest()->limit(100)->get();
    }
    public function myRequests(Request $request)
    {
        $query = auth()->user()->requestedWorkOrders()
            ->whereIn('status', ['on_request', 'overdue ', 'in_progress', 'on_hold']);
        $this->applyFilters($query, $request);

        return $query->with([
            'engineer:id,name',
            'department:id,name',
            'requester:id,name',
            'cancelledByUser:id,name',
            'comments.user'
        ])->latest()->limit(100)->get();
    }

    public function myRequestsHistory(Request $request)
    {
        $query = auth()->user()->requestedWorkOrders();
        $this->applyFilters($query, $request);

        return $query->with([
            'engineer:id,name',
            'department:id,name',
            'requester:id,name',
            'cancelledByUser:id,name',
            'comments.user'
        ])->latest()->limit(100)->get();
    }
    public function myAssignments(Request $request)
    {
        $query = auth()->user()->assignedWorkOrders()
            ->whereIn('status', ['assigned', 'in_progress', 'on_hold', 'overdue']);

        if ($request->search) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%$search%")
                    ->orWhere('description', 'like', "%$search%");
            });
        }

        return $query->with([
            'engineer:id,name',
            'department:id,name',
            'requester:id,name',
            'cancelledByUser.department:id,name',
            'comments.user'

        ])->latest()->get();
    }

    public function myAssignmentsHistory(Request $request)
    {
        $query = auth()->user()->assignedWorkOrders()
            ->whereIn('status', ['completed', 'cancelled', 'in_progress', 'on_hold', 'overdue']);
        $this->applyFilters($query, $request);

        return $query->with([
            'engineer:id,name',
            'department:id,name',
            'requester:id,name',
            'cancelledByUser.department:id,name',
            'comments.user'
        ])->latest()->get();
    }

    public function availableAssignments(Request $request)
    {
        $query = WorkOrder::where('status', 'on_request');

        // only search/range here, status is hardcoded to on_request
        if ($request->search) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%$search%")
                    ->orWhere('description', 'like', "%$search%");
            });
        }

        return $query->with([
            'engineer:id,name',
            'department:id,name',
            'requester:id,name',
            'cancelledByUser.department:id,name',
            'comments.user'
        ])->latest()->get();
    }

    public function pagination(Request $request)
    {
        $perPage = $request->get('per_page', 10);
        $sortBy = $request->get('sort_by', 'created_at');
        $sortDir = $request->get('sort_dir', 'desc');

        $query = WorkOrder::select('work_orders.*')
            ->with('requester')
            ->leftJoin('users', 'work_orders.requester_id', '=', 'users.id');
        $search = $request->get('search');

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('work_orders.title', 'like', "%$search%")
                    ->orWhere('work_orders.status', 'like', "%$search%")
                    ->orWhere('users.name', 'like', "%$search%");

                if (is_numeric($search)) {
                    $q->orWhere('work_orders.id', (int) $search);
                }
            });
        }

        if ($request->range) {
            switch ($request->filled('range')) {
                case 'days30':
                    $query->where('work_orders.created_at', '>=', now()->subDays(30));
                    break;

                case 'weeks2':
                    $query->where('work_orders.created_at', '>=', now()->subWeeks(2));
                    break;

                case 'week1':
                    $query->where('work_orders.created_at', '>=', now()->subWeek());
                    break;

                case 'day1':
                    $query->where('work_orders.created_at', '>=', now()->subDay());
                    break;
            }
        }

        if ($sortBy === 'requester') {
            $query->orderBy('users.name', $sortDir);
        } else {
            $query->orderBy("work_orders.$sortBy", $sortDir);
        }

        $orders = $query->paginate($perPage);

        return response()->json($orders);
    }

    public function destroy($id)
    {
        WorkOrder::findOrFail($id)->delete();

        return response()->json(['message' => 'WorkOrder Deleted'], 200);
    }


    public function assign(Request $request, $id)
    {
        $request->validate([
            'engineer_id' => 'required|exists:users,id',
            'due_at' => 'nullable|date'
        ]);

        $engineer = User::findOrFail($request->engineer_id);

        if (!$engineer->hasRole('engineer')) {
            return response()->json(['message' => 'User is not an engineer'], 422);
        }

        $workOrder = WorkOrder::findOrFail($id);

        $workOrder->update([
            'assigned_engineer_id' => $request->engineer_id,
            'assigned_at' => now(),
            'due_at' => $request->due_at,
            'status' => 'assigned',
        ]);

        return response()->json(['message' => 'Engineer Assigned Successfully']);
    }


    public function start($id)
    {
        $order = WorkOrder::findOrFail($id);

        if ($order->status !== 'on_request') {
            return response()->json([
                'message' => 'Work order is not on request status'
            ], 400);
        }

        $order->update([
            'assigned_engineer_id' => auth()->id(),
            'status' => 'in_progress',
            'started_at' => now(),
        ]);

        return response()->json([
            'message' => 'Work Order Started',
            'order' => $order
        ]);
    }


    public function complete($id)
    {
        $order = WorkOrder::findOrFail($id);

        if ($order->assigned_engineer_id !== auth()->id()) {
            abort(403);
        }

        $order->update([
            'status' => 'completed',
            'completed_at' => now()
        ]);
        return response()->json(['message' => 'Work Order Completed']);
    }

    public function confirm($id)
    {
        $order = WorkOrder::findOrFail($id);

        $order->update([
            'status' => 'completed'
        ]);

        return response()->json(['message' => 'Work Order Confirmed as Completed']);
    }

    public function cancel(Request $request, $id)
    {
        $order = WorkOrder::findOrFail($id);
        $user = auth()->user();

        $isRequester = $order->requester_id === $user->id;
        $isAssignedEngineer = $order->assigned_engineer_id === $user->id;  // ← add
        $isAuthorized = $isRequester || $isAssignedEngineer || $user->hasAnyRole('admin', 'superadmin');

        if (!$isAuthorized) {
            abort(403);
        }

        $order->update([
            'status' => 'cancelled',
            'cancelled_by' => $user->id,
            'cancelled_role' => $user->getRoleNames()->first(),
            'cancelled_at' => now()
        ]);

        if ($request->comment) {
            Comment::create([
                'work_order_id' => $order->id,
                'user_id' => $user->id,
                'comment' => $request->comment,
                'created_at' => now(),
            ]);
        }

        return response()->json(['message' => 'Work Order Cancelled']);
    }
    public function hold(Request $request, $id)
    {
        $order = WorkOrder::findOrFail($id);
        if ($order->status !== 'in_progress') {
            return response()->json([
                'message' => 'Work order is not in progress'
            ], 400);
        }

        $order->update([
            'status' => 'on_hold',
        ]);

        if ($request->comment) {
            Comment::create([
                'work_order_id' => $order->id,
                'user_id' => auth()->id(),
                'comment' => $request->comment,
                'created_at' => now(),
            ]);
        }
        return response()->json(['message' => 'Work Order Put on Hold', 'order' => $order]);
    }

    public function resume($id)
    {
        $order = WorkOrder::findOrFail($id);

        if ($order->status !== 'on_hold') {
            return response()->json([
                'message' => 'Work order is not on hold'
            ], 400);
        }

        $order->update([
            'status' => 'in_progress',
            'held_at' => null,
        ]);

        return response()->json(['message' => 'Work Order Resumed', 'order' => $order]);
    }

    // in WorkOrderController
    public function calendar(Request $request)
    {
        $month = $request->get('month', now()->month);
        $year = $request->get('year', now()->year);

        $start = \Carbon\Carbon::create($year, $month, 1)->startOfMonth();
        $end = \Carbon\Carbon::create($year, $month, 1)->endOfMonth();

        $orders = WorkOrder::with(['requester:id,name', 'department:id,name', 'engineer:id,name'])
            ->where(function ($q) use ($start, $end) {
                $q->whereBetween('created_at', [$start, $end])
                    ->orWhereBetween('due_at', [$start, $end])
                    ->orWhereBetween('completed_at', [$start, $end]);
            })
            ->get();

        // group by date
        $grouped = [];

        foreach ($orders as $order) {
            $dates = [];

            if ($order->created_at)
                $dates[] = ['date' => $order->created_at->toDateString(), 'type' => 'created'];
            if ($order->due_at)
                $dates[] = ['date' => $order->due_at->toDateString(), 'type' => 'due'];
            if ($order->completed_at)
                $dates[] = ['date' => $order->completed_at->toDateString(), 'type' => 'completed'];

            foreach ($dates as $entry) {
                $date = $entry['date'];
                if (!isset($grouped[$date])) {
                    $grouped[$date] = [];
                }
                // avoid duplicate order entries per date
                $exists = collect($grouped[$date])->contains('id', $order->id);
                if (!$exists) {
                    $grouped[$date][] = [
                        'id' => $order->id,
                        'title' => $order->title,
                        'status' => $order->status,
                        'department' => $order->department?->name,
                        'requester' => $order->requester?->name,
                        'engineer' => $order->engineer?->name,
                        'created_at' => $order->created_at?->toDateString(),
                        'due_at' => $order->due_at?->toDateString(),
                        'completed_at' => $order->completed_at?->toDateString(),
                    ];
                }
            }
        }

        return response()->json($grouped);
    }

    public function gantt(Request $request)
    {
        $start = \Carbon\Carbon::parse($request->get('start'))->startOfDay();
        $end = \Carbon\Carbon::parse($request->get('end'))->endOfDay();

        $orders = WorkOrder::with([
            'requester:id,name',
            'department:id,name',
            'engineer:id,name',
        ])
            ->where(function ($q) use ($start, $end) {
                // orders that overlap with the range
                $q->whereBetween('created_at', [$start, $end])
                    ->orWhereBetween('due_at', [$start, $end])
                    ->orWhere(function ($q2) use ($start, $end) {
                    $q2->where('created_at', '<=', $start)
                        ->where(function ($q3) use ($end) {
                            $q3->where('due_at', '>=', $end)
                                ->orWhereNull('due_at');
                        });
                });
            })
            ->limit(100)
            ->get()
            ->map(function ($order) {
                return [
                    'id' => $order->id,
                    'title' => $order->title,
                    'status' => $order->status,
                    'requester' => $order->requester?->name,
                    'department' => $order->department?->name,
                    'engineer' => $order->engineer?->name,
                    'created_at' => $order->created_at?->toDateString(),
                    'due_at' => $order->due_at?->toDateString(),
                    'completed_at' => $order->completed_at?->toDateString(),
                    'overdue_at' => $order->overdue_at?->toDateString(),
                ];
            });

        return response()->json($orders);
    }
}
