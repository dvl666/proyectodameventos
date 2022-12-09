<?php

namespace App\Http\Controllers;

use App\Models\DetallePago;
use Illuminate\Http\Request;

class DetallePagosController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return DetallePago::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $detallePago = new DetallePago();
        $detallePago->id_detalle = $request->id_detalle;
        $detallePago->id_evento = $request->id_evento;
        $detallePago->usuario = $request->usuario;
        $detallePago->save();
        return $detallePago;
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\DetallePago  $detallePago
     * @return \Illuminate\Http\Response
     */
    public function show(DetallePago $detallePago)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\DetallePago  $detallePago
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, DetallePago $detallePago)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\DetallePago  $detallePago
     * @return \Illuminate\Http\Response
     */
    public function destroy(DetallePago $detallePago)
    {
        //
    }
}
