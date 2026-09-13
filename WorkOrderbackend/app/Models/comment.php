<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    protected $table = 'work_order_comments';    // ← add this

    public $timestamps = false;

    protected $fillable = [
        'work_order_id',
        'user_id',
        'comment',
        'created_at',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function workOrder()
    {
        return $this->belongsTo(WorkOrder::class);
    }
}
