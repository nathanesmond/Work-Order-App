<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WorkOrder extends Model
{
    protected $fillable = [
        'title',
        'description',
        'requester_id',
        'assigned_engineer_id',
        'department_id',
        'priority_id',
        'status',
        'due_at',
        'assigned_at',
        'started_at',
        'completed_at',
        'cancelled_at',
        'overdue_at',
        'cancelled_by',
        'cancelled_role',
    ];

    protected $casts = [
        'due_at' => 'datetime',
        'assigned_at' => 'datetime',
        'started_at' => 'datetime',
        'completed_at' => 'datetime',
        'cancelled_at' => 'datetime',
        'overdue_at' => 'datetime',
    ];

    public function requester()
    {
        return $this->belongsTo(User::class, 'requester_id');
    }

    public function engineer()
    {
        return $this->belongsTo(User::class, 'assigned_engineer_id');
    }

    public function department()
    {
        return $this->belongsTo(Department::class);
    }

    public function cancelledByUser()
    {
        return $this->belongsTo(User::class, 'cancelled_by');
    }

    public function comments()
    {
        return $this->hasMany(Comment::class)->with('user')->latest('created_at');
    }
}
