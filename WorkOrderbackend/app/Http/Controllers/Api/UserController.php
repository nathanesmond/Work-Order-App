<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Department;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    public function index(Request $request)
    {
        $query = User::query();

        if ($request->search) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%$search%")
                    ->orWhere('username', 'like', "%$search%");
            });
        }

        if ($request->department_id) {
            $query->where('department_id', $request->department_id);
        }

        return $query
            ->with(['roles', 'department:id,name'])
            ->get();
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:150',
                'username' => [
                    'required',
                    'string',
                    \Illuminate\Validation\Rule::unique('users', 'username')->whereNull('deleted_at'),
                ],
                'password' => 'required|string|min:6',
                'role' => 'required|string',
                'department_id' => 'required|exists:departments,id',
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => $e->validator->errors()->first(),
            ], 422);
        }

        $user = User::create([
            'name' => $request->name,
            'username' => $request->username,
            'password' => \Hash::make($request->password),
            'department_id' => $request->department_id,
        ]);

        $user->assignRole($request->role);

        return response()->json(
            $user->load(['roles', 'department:id,name']),
            201
        );
    }
    public function show()
    {
        auth()->user();
        return User::with(['roles', 'department'])->findOrFail(auth()->id());
    }

    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);

        $data = $request->validate([
            'name' => 'sometimes|string|max:150',
            'username' => 'sometimes|string|unique:users,username,' . $id,
            'password' => 'nullable|min:6',
            'role' => 'nullable|string',
            'department_id' => 'nullable|exists:departments,id',
        ]);

        if (isset($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        }

        $user->update($data);

        if (isset($data['role'])) {
            $user->syncRoles([$data['role']]);
        }

        return response()->json($user->load('roles'));
    }

    public function destroy($id)
    {
        User::findOrFail($id)->delete();

        return response()->json(['message' => 'User deleted']);
    }
}
