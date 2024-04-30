<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\Reviews;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DashboardController extends Controller
{
    // Основний метод для відображення головної сторінки панелі керування лікаря
    public function index()
    {
        // Отримати залогіненого лікаря
        $doctor = Auth::user();

        // Отримати майбутні записи лікаря
        $appointments = $this->getUpcomingAppointments($doctor->id);

        // Отримати відгуки від активних користувачів про лікаря
        $reviews = $this->getActiveReviews($doctor->id);

        // Передати змінні до відображення
        return view('dashboard')->with(compact('doctor', 'appointments', 'reviews'));
    }

    // Приватний метод для отримання майбутніх записів лікаря
    private function getUpcomingAppointments($doctorId)
    {
        return Appointments::where('doctor_id', $doctorId)
            ->where('status', 'upcoming')
            ->get();
    }

    // Приватний метод для отримання відгуків від активних користувачів про лікаря
    private function getActiveReviews($doctorId)
    {
        return Reviews::where('doctor_id', $doctorId)
            ->where('status', 'active')
            ->get();
    }

    // Метод для отримання відгуків від активних користувачів  (API)
    public function getReviews()
    {
        $reviews = Reviews::where('status', 'active')->get();
        return response()->json(['reviews' => $reviews], 200);
    }

    // Метод для збереження нового відгуку та позначення запису як завершеного (API)
    public function store(Request $request)
    {
        // Створення нового відгуку
        $reviews = Reviews::create([
            'account_id' => Auth::user()->id,
            'doctor_id' => $request->input('doctor_id'),
            'ratings' => $request->input('ratings'),
            'reviews' => $request->input('reviews'),
            'reviewed_by' => Auth::user()->name,
            'status' => 'active',
        ]);

        // Позначення запису як завершеного
        $appointment = Appointments::findOrFail($request->input('appointment_id'));
        $appointment->status = 'complete';
        $appointment->save();

        // Повернення повідомлення про успіх
        return response()->json(['success' => 'Запис успішно завершено та відгук залишено!'], 200);
    }

    public function show($id)
    {
    }

    public function edit($id)
    {
    }

    public function update(Request $request, $id)
    {
    }

    public function destroy($id)
    {
    }
}
