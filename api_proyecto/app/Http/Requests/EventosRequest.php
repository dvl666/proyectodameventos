<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class EventosRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules()
    {
        return [
            'nombre' => 'required|max:50',
            'descripcion' => 'required|max:50',
            'precio' => 'required|numeric|gte:0',
            'estado' => 'required',
            'fecha' => 'required',
            'cant_entradas' => 'required|numeric|gt:0'
        ];
    }

    public function messages(){
        return [
            'nombre.required' => 'Indique el nombre de evento',
            'nombre.max' => 'El nombre no puede tener más de 50 caracteres',
            'descripcion.required' => 'Indique la descrpcion del evento',
            'descripcion.max' => 'La descripcion no puede tener más de 50 caracteres',
            'precio.required' => 'Indique el precio de evento',
            'precio.numeric' => 'Precio debe ser un número',
            'precio.gte' => 'El precio debe ser mayor o igual a cero',
            'estado.required' => 'Indique el estado del evento',
            'fecha.required' => 'Indique la fecha del evento',
            'cant_entradas.gt' => 'La cantidad de entradas debe ser mayor a cero',
            'cant_entradas.required' => 'Indique la cantidad de entradas del evento',
            'cant_entradas.numeric' => 'La cantidad de entradas debe ser un número',
        ];
    }
}
