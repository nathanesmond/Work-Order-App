<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;
use Illuminate\Database\Eloquent\SoftDeletes;

use App\Models\WorkOrder;
use App\Models\Department;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, HasRoles, softDeletes;

    protected $fillable = [
        'name',
        'username',
        'password',
        'department_id',
        'fcm_token',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    // requester -> created orders
    public function requestedWorkOrders()
    {
        return $this->hasMany(WorkOrder::class, 'requester_id');
    }

    public function assignedWorkOrders()
    {
        return $this->hasMany(WorkOrder::class, 'assigned_engineer_id');
    }

    public function department()
    {
        return $this->belongsTo(Department::class);
    }
}
