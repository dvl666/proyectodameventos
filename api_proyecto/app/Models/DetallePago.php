<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class DetallePago extends Model
{
    use HasFactory,SoftDeletes;

    protected $table = 'detalle_pagos';
    protected $primaryKey = 'id_detalle';
    
    public $timestamps = false;
    public $incrementing = true;

    public function usuarios(){
        return $this->belongsToMany(Usuario::class,'id_evento','fecha','precio',);
    }
    
}
