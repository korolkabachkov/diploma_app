<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\User;
use App\Models\Doctor;
use App\Models\UserAttributes;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class UsersController extends Controller
{
    // Показує дані профілю користувача
    public function index()
    {
        $loggedInUser = Auth::user();
        $userDetails = $loggedInUser->user_attributes;
        $doctors = User::where('type', 'doctor')->get();
        $doctorData = Doctor::all();
        $nearestAppointment = $this->getNearestAppointment(now()->format('n/j/Y'));

        $doctorData = $this->addDoctorInformation($doctorData, $doctors, $nearestAppointment);

        $loggedInUser->doctor = $doctorData;
        $loggedInUser->details = $userDetails;

        return $loggedInUser;
    }

    // Метод для аутентифікації користувача
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            throw ValidationException::withMessages([
                'email' => ['Введені дані невірні'],
            ]);
        }

        return $this->generateAuthToken($request->user());
    }

    // Метод для виходу користувача з системи
    public function logout()
    {
        Auth::user()->currentAccessToken()->delete();
        return $this->logoutSuccessResponse();
    }

    // Метод для реєстрації нового користувача
    public function register(Request $request)
    {
        $validatedData = $this->validateRegistrationData($request);
        $user = $this->createUser($validatedData);
        $userInfo = $this->createUserAttributes($user);
        return $user;
    }

    // Метод для збереження списку улюблених лікарів користувача
    public function storeFavouriteDoctor(Request $request)
    {
        $user = Auth::user();
        $userAttributes = $this->getUserAttributes($user);
        $this->updateFavouriteDoctorsList($userAttributes, $request);
        return $this->favouriteDoctorsUpdateSuccessResponse();
    }

    // Функція для отримання найближчого майбутнього прийому
    private function getNearestAppointment($date)
    {
        return Appointments::where('status', 'upcoming')->where('date', $date)->first();
    }

    // Функція для додавання інформації про лікарів до їх даних
    private function addDoctorInformation($doctorData, $doctors, $nearestAppointment)
    {
        foreach ($doctorData as $data) {
            foreach ($doctors as $info) {
                if ($data->doctor_id == $info->id) {
                    $data->doctor_name = $info->name;
                    $data->doctor_profile = $info->profile_photo_url;
                    if ($nearestAppointment && $nearestAppointment->doctor_id == $info->id) {
                        $data->appointments = $nearestAppointment;
                    }
                }
            }
        }
        return $doctorData;
    }

    // Метод для генерації токену для авторизації
    private function generateAuthToken($user)
    {
        return $user->createToken($user->email)->plainTextToken;
    }

    // Метод для створення відповіді про успішний вихід
    private function logoutSuccessResponse()
    {
        return response()->json(['success' => 'Користувач вийшов з системи успішно!'], 200);
    }

    // Метод для валідації даних реєстрації
    private function validateRegistrationData(Request $request)
    {
        return $request->validate([
            'name' => 'required|string',
            'email' => 'required|email',
            'password' => 'required',
        ]);
    }

    // Метод для створення нового користувача
    private function createUser($validatedData)
    {
        return User::create([
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'type' => 'user',
            'password' => Hash::make($validatedData['password']),
        ]);
    }

    // Метод для створення атрибутів користувача
    private function createUserAttributes($user)
    {
        return UserAttributes::create([
            'account_id' => $user->id,
            'status' => 'active',
        ]);
    }

    // Метод для отримання атрибутів користувача
    private function getUserAttributes($user)
    {
        $userAttributes = UserAttributes::where('account_id', $user->id)->first();

        if (!$userAttributes) {
            $userAttributes = new UserAttributes();
            $userAttributes->account_id = $user->id;
        }

        return $userAttributes;
    }

    // Метод для оновлення списку улюблених лікарів користувача
    private function updateFavouriteDoctorsList($userAttributes, $request)
    {
        $doctorList = json_encode($request->input('favouriteList', []));
        $userAttributes->favourite = $doctorList;
        $userAttributes->save();
    }

    // Метод для повернення відповіді про успішне оновлення списку улюблених лікарів
    private function favouriteDoctorsUpdateSuccessResponse()
    {
        return response()->json(['success' => 'Список улюблених лікарів оновлено'], 200);
    }

    public function show(string $id) {}
    public function edit(string $id) {}
    public function update(Request $request, string $id) {}
    public function destroy(string $id) {}
    public function create() {}
}
