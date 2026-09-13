<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WorkOrderNotification extends Model
{
    protected $table = 'notifications';

    protected $fillable = [
        'user_id',
        'work_order_id',
        'type',
        'title',
        'message',
        'is_read',
    ];

    protected $casts = [
        'is_read' => 'boolean',
    ];

    public function workOrder()
    {
        return $this->belongsTo(WorkOrder::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}