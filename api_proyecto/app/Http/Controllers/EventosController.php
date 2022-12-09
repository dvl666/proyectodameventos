<?php

namespace App\Http\Controllers;

use App\Models\Evento;
use Illuminate\Http\Request;
use App\Http\Requests\EventosRequest;


class EventosController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return $evento = Evento::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(EventosRequest $request)
    {
        $evento = new Evento();
        $evento->id_evento = $request->id_evento;
        $evento->nombre = $request->nombre;
        $evento->descripcion = $request->descripcion;
        $evento->fecha = $request->fecha;
        $evento->precio = $request->precio;
        $evento->cant_entradas = $request->cant_entradas;
        $evento->estado = $request->estado;
        $evento->save();
        return $evento;
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Evento  $evento
     * @return \Illuminate\Http\Response
     */
    public function show(Evento $evento)
    {
        return $evento;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Evento  $evento
     * @return \Illuminate\Http\Response
     */
    public function update(EventosRequest $request, Evento $evento)
    {

        $evento->nombre = $request->nombre;
        $evento->descripcion = $request->descripcion;
        $evento->fecha = $request->fecha;
        $evento->precio = $request->precio;
        $evento->cant_entradas = $request->cant_entradas;
        $evento->estado = $request->estado;
        $evento->save();
        return $evento;
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Evento  $evento
     * @return \Illuminate\Http\Response
     */
    public function destroy(Evento $evento)
    {
        $evento->delete();
    }
}
