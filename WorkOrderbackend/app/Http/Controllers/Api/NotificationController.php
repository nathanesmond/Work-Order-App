<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\WorkOrderNotification as Notification;

class NotificationController extends Controller
{
    public function saveFcmToken(Request $request)
    {
        $request->validate(['fcm_token' => 'required|string']);
        auth()->user()->update(['fcm_token' => $request->fcm_token]);
        return response()->json(['message' => 'FCM token saved']);
    }


    public function index()
    {
        $notifications = Notification::where('user_id', auth()->id())
            ->with('workOrder:id,title,status')
            ->latest()
            ->get();

        return response()->json($notifications);
    }

    public function unreadCount()
    {
        $count = Notification::where('user_id', auth()->id())
            ->where('is_read', false)
            ->count();

        return response()->json(['count' => $count]);
    }

    public function markRead($id)
    {
        $notification = Notification::where('user_id', auth()->id())
            ->findOrFail($id);

        $notification->update(['is_read' => true]);

        return response()->json(['message' => 'Marked as read']);
    }

    public function markAllRead()
    {
        Notification::where('user_id', auth()->id())
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return response()->json(['message' => 'All marked as read']);
    }


}