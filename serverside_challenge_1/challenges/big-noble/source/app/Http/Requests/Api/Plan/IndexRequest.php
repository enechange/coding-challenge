<?php

namespace App\Http\Requests\Api\Plan;

use App\Enum\AmpereEnum;
use App\Http\Requests\Api\ApiRequest;
use Illuminate\Validation\Rules\Enum;

class IndexRequest extends ApiRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'ampere' => ['required', new Enum(AmpereEnum::class)],
            'use_power' => ['required', 'integer', 'min:0']
        ];
    }

    /**
     * @inheritDoc
     */
    public function attributes(): array
    {
        return [
            'ampere' => '契約アンペア数',
            'use_power' => '使用量'
        ];
    }
}
