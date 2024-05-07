<?php

namespace App\Providers;

use App\Service\PlanCalculateService;
use App\Service\PlanCalculateServiceInterface;
use App\Service\PlanService;
use App\Service\PlanServiceInterface;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        app()->bind(PlanServiceInterface::class, PlanService::class);
        app()->bind(PlanCalculateServiceInterface::class, PlanCalculateService::class);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
