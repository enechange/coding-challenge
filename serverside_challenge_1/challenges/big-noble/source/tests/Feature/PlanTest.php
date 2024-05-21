<?php

namespace Tests\Feature;

use Tests\TestCase;

class PlanTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    public function test_success(): void
    {
        $ampere = 15;
        $usePower = 1;
        $response = $this->get("api/plan/index?ampere=$ampere&use_power=$usePower");

        $response->assertStatus(200);
    }

    public function test_error(): void
    {
        $ampere = 99;
        $usePower = 1;
        $response = $this->get("api/plan/index?ampere=$ampere&use_power=$usePower");

        $response->assertStatus(400);
    }
}
