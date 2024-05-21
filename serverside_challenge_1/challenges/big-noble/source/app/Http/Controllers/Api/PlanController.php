<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\Plan\IndexRequest;
use App\Service\PlanServiceInterface;
use Illuminate\Http\JsonResponse;

class PlanController extends Controller
{
    public function __construct(private readonly PlanServiceInterface $service)
    {}

    /**
     * プラン一覧を取得
     *
     * @param IndexRequest $request
     * @return JsonResponse
     */
    public function index(IndexRequest $request): JsonResponse
    {
        $ampere = $request->validated('ampere');
        $usePower = $request->validated('use_power');

        $responsePlans = $this->service->getPlanPrices($ampere, $usePower);

        return response()->json($responsePlans);
    }
}
