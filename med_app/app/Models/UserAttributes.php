<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserAttributes extends Model
{
    use HasFactory;

    //these are fillable input
    protected $fillable = [
        'account_id',
        'bio_data',
        'favourite',
        'status',
    ];

    //state this is belong to user table
    public function user(){
        return $this->belongsTo(User::class);
    }
}
