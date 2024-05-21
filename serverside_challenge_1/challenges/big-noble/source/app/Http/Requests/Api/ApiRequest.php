<?php

namespace App\Http\Requests\Api;

use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class ApiRequest extends FormRequest
{
    /**
     * @inheritDoc
     */
    protected function failedValidation(Validator $validator): void
    {
        $response = response()->json([
            'errors' => $validator->errors()
        ], 400);
        throw new HttpResponseException($response);
    }
}
