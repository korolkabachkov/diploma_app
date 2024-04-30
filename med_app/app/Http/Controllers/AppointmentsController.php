<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AppointmentsController extends Controller
{
    public function index()
    {
        // Отримання ідентифікатора поточного користувача
        $patient_id = Auth::user()->id;
        // Отримання всіх записів користувача
        $appointments = Appointments::where('account_id', $patient_id)->get();

        // Додавання інформації про лікаря до кожного запису
        $appointments->transform(function ($appointment) {
            // Знаходження лікаря, пов'язаного з записом
            $doctor = User::find($appointment->doctor_id);
            // Додавання імені лікаря до запису
            $appointment['doctor_name'] = $doctor->name;
            // Додавання URL профілю лікаря до запису
            $appointment['doctor_profile'] = $doctor->profile_photo_url;
            // Додавання категорії лікаря до запису (якщо вона є)
            $appointment['category'] = optional($doctor->doctor)->category;
            return $appointment;
        });

        // Повернення списку записів користувача
        return $appointments;
    }

    public function store(Request $request)
    {
        // Отримання ідентифікатора поточного користувача
        $patient_id = Auth::user()->id;

        // Створення нового запису до лікаря
        $appointment = Appointments::create([
            'account_id' => $patient_id,
            'doctor_id' => $request->input('doctor_id'),
            'date' => $request->input('date'),
            'day' => $request->input('day'),
            'time' => $request->input('time'),
            'status' => 'upcoming',
        ]);

        // Повернення відповіді з повідомленням про успіх
        return response()->json([
            'success' => 'Запис до лікаря було успішно створено!',
        ], 200);
    }

    public function create()
    {
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
