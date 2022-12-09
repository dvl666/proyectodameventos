<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('eventos', function (Blueprint $table) {
            $table->unsignedInteger('id_evento')->autoIncrement();
            $table->string('nombre',50);
            $table->string('descripcion',50);
            $table->string('fecha');
            $table->unsignedInteger('precio');
            $table->unsignedInteger('cant_entradas');
            $table->boolean('estado');
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('eventos');
    }
};
