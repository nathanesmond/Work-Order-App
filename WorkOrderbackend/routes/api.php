<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\WorkOrderController;
use App\Http\Controllers\Api\NotificationController;
use Illuminate\Http\Request;

Route::post('/login', [AuthController::class, 'login']);

Route::get('/showUser', [UserController::class, 'show'])->middleware('auth:sanctum');

Route::middleware('auth:sanctum')->get('/me', function (Request $request) {
    return $request->user()->load('roles');
});


Route::middleware(['auth:sanctum'])->get('/engineers', function () {
    return \App\Models\User::role('engineer')->get();
});

Route::middleware(['auth:sanctum'])->group(function () {

    Route::get('/viewAllWorkOrders', [WorkOrderController::class, 'index'])
        ->middleware('role:admin|requester|superadmin');

    Route::delete('/deleteWorkOrder/{id}', [WorkOrderController::class, 'destroy'])
        ->middleware('role:admin|requester|superadmin');

    Route::put('/WorkOrder/{id}/confirm', [WorkOrderController::class, 'confirm'])
        ->middleware('  role:requester|admin|superadmin');

    Route::put('/WorkOrder/{id}/cancel', [WorkOrderController::class, 'cancel'])
        ->middleware('role:admin|superadmin');

    Route::post('/createWorkOrder', [WorkOrderController::class, 'store'])
        ->middleware('role:requester');

    Route::get('/myWorkOrders', [WorkOrderController::class, 'myRequests'])
        ->middleware('role:requester');
    Route::get('/myWorkOrderHistory', [WorkOrderController::class, 'myRequestsHistory'])
        ->middleware('role:requester');

    Route::put('/WorkOrder/{id}/assign', [WorkOrderController::class, 'assign'])
        ->middleware('role:engineer');

    Route::get('/myAssignments', [WorkOrderController::class, 'myAssignments'])
        ->middleware('role:engineer');

    Route::Get('/myHistory', [WorkOrderController::class, 'myAssignmentsHistory'])
        ->middleware('role:engineer');

    Route::put('/WorkOrder/{id}/start', [WorkOrderController::class, 'start'])
        ->middleware('role:engineer');

    Route::put('/WorkOrder/{id}/complete', [WorkOrderController::class, 'complete'])
        ->middleware('role:engineer');

    Route::put('/WorkOrder/{id}/hold', [WorkOrderController::class, 'hold']);
    Route::put('/WorkOrder/{id}/resume', [WorkOrderController::class, 'resume']);

    Route::get('/availableAssignments', [WorkOrderController::class, 'availableAssignments'])
        ->middleware('role:engineer');

    Route::get('/users', [UserController::class, 'index'])
        ->middleware('role:admin|superadmin');

    Route::get('/paginateWorkOrders', [WorkOrderController::class, 'pagination'])
        ->middleware('role:admin|superadmin');

    Route::post('/fcm-token', [NotificationController::class, 'saveFcmToken']);

    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);
    Route::put('/notifications/{id}/read', [NotificationController::class, 'markRead']);
    Route::put('/notifications/read-all', [NotificationController::class, 'markAllRead']);

    Route::get('/calendar', [WorkOrderController::class, 'calendar'])
        ->middleware('role:admin|superadmin');

    Route::get('/calendar/gantt', [WorkOrderController::class, 'gantt'])
        ->middleware('role:admin|superadmin');
});

Route::middleware(['auth:sanctum', 'role:superadmin'])->group(function () {
    Route::post('/createUser', [UserController::class, 'store']);
    Route::put('/updateUser/{id}', [UserController::class, 'update']);
    Route::delete('/deleteUser/{id}', [UserController::class, 'destroy']);
});



Route::middleware(['auth:sanctum', 'role:requester'])->group(function () {
    Route::post('/work-orders', [WorkOrderController::class, 'store']);
});

Route::middleware(['auth:sanctum', 'role:engineer'])->group(function () {
    Route::get('/assigned-work-orders', [WorkOrderController::class, 'assigned']);
});


Route::get('/ping', function () {
    return response()->json(['message' => 'API working']);
});
