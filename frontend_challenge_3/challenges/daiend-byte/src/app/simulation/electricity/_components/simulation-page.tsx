'use client';

import { zodResolver } from '@hookform/resolvers/zod';
import { FormProvider, useForm } from 'react-hook-form';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/form';
import { SectionCard } from '@/components/ui/section-card';
import { CapacitySelect } from '@/features/simulation/components/capacity-select';
import { PlanSelect } from '@/features/simulation/components/plan-select';
import { ProviderSelect } from '@/features/simulation/components/provider-select';
import { ZipCodeField } from '@/features/simulation/components/zip-code-field';
import {
    simulationFormSchema,
    type SimulationFormInput,
    type SimulationFormOutput,
} from '@/features/simulation/schemas/simulation-form-schema';

const defaultValues: SimulationFormInput = {
    zipCode: '',
    areaId: null,
    providerId: null,
    planId: null,
    capacityValue: null,
    electricityBill: '',
    email: '',
};

export function SimulationPage() {
    const form = useForm<SimulationFormInput, unknown, SimulationFormOutput>({
        resolver: zodResolver(simulationFormSchema),
        mode: 'onBlur',
        defaultValues,
    });
    const {
        register,
        handleSubmit,
        formState: { errors, isValid, touchedFields },
    } = form;

    // 結果ページ（/simulation/electricity/result）は本課題のスコープ外（ADR-0003）。
    // 現時点ではvalidな入力値をそのまま出力する。
    function onSubmit(values: SimulationFormOutput) {
        console.log(values);
    }

    return (
        <main className="flex flex-1 flex-col bg-background">
            <header className="flex flex-col items-center gap-3 px-4 py-10 text-center">
                <h1 className="text-xl font-bold text-text">
                    電気代から
                    <br />
                    かんたんシミュレーション
                </h1>
                <p className="text-base text-text">
                    検針票を用意しなくてもOK
                    <br />
                    いくらおトクになるのか今すぐわかります！
                </p>
            </header>
            <FormProvider {...form}>
                <form
                    noValidate
                    className="flex flex-col gap-4 pb-10"
                    onSubmit={(event) => {
                        void handleSubmit(onSubmit)(event);
                    }}
                >
                    <SectionCard heading="郵便番号をご入力ください">
                        <ZipCodeField />
                    </SectionCard>
                    <SectionCard heading="電気のご使用状況について教えてください">
                        <ProviderSelect />
                        <PlanSelect />
                        <CapacitySelect />
                    </SectionCard>
                    <SectionCard heading="現在の電気の使用状況について教えてください">
                        <Input
                            type="text"
                            inputMode="numeric"
                            label="先月の電気代は？"
                            required
                            placeholder="5000"
                            error={
                                touchedFields.electricityBill
                                    ? errors.electricityBill?.message
                                    : undefined
                            }
                            registration={register('electricityBill')}
                        />
                    </SectionCard>
                    <SectionCard heading="メールアドレスをご入力ください">
                        <Input
                            type="email"
                            label="メールアドレス"
                            required
                            placeholder="example@enechange.co.jp"
                            error={
                                touchedFields.email
                                    ? errors.email?.message
                                    : undefined
                            }
                            registration={register('email')}
                        />
                    </SectionCard>
                    <div className="px-5">
                        <Button type="submit" disabled={!isValid}>
                            結果を見る
                        </Button>
                    </div>
                </form>
            </FormProvider>
        </main>
    );
}
