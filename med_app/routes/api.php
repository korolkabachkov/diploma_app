<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UsersController;
use App\Http\Controllers\AppointmentsController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\MessageController;

Route::post('/login', [UsersController::class, 'login']);
Route::post('/register', [UsersController::class, 'register']);

Route::middleware('auth:sanctum')->group(function() {
    Route::get('/user', [UsersController::class, 'index']);
    Route::post('/favourite', [UsersController::class, 'storeFavouriteDoctor']);
    Route::post('/logout', [UsersController::class, 'logout']);
    Route::post('/book', [AppointmentsController::class, 'store']);
    Route::get('/appointments', [AppointmentsController::class, 'index']);
    Route::post('/reviews', [DashboardController::class, 'store']);
    Route::get('/reviews', [DashboardController::class, 'getReviews']);
});