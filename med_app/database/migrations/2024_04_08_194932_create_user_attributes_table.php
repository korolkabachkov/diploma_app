<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('user_attributes', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedBigInteger('account_id')->unique();
            $table->longText('bio_data')->nullable();
            $table->string('status')->nullable();
            $table->foreign('account_id')->references('id')->on('users')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_attributes');
    }
};
