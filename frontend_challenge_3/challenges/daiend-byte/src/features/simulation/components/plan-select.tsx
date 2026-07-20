'use client';

import { useEffect } from 'react';
import { useController, useFormContext, useWatch } from 'react-hook-form';

import { Select } from '@/components/ui/form';

import { getPlan, getProvider } from '../data/selectors';
import type { SimulationFormInput } from '../schemas/simulation-form-schema';

export function PlanSelect() {
    const {
        control,
        setValue,
        formState: { errors },
    } = useFormContext<SimulationFormInput>();
    const areaId = useWatch({ control, name: 'areaId' });
    const providerId = useWatch({ control, name: 'providerId' });
    const {
        field: { value, onChange, onBlur, name },
    } = useController({ control, name: 'planId' });

    useEffect(() => {
        setValue('planId', null);
        // providerId が変わるたびに自身をリセットする。capacityValueのリセットは
        // 下のuseEffect（planId自体の変化を監視）が担う
    }, [providerId, setValue]);

    useEffect(() => {
        setValue('capacityValue', null);
        // planId が変わるたびに下流（契約容量）をリセットする。同一プロバイダ内で
        // プランを切り替えた場合（providerIdは変わらない）もここで確実に拾う
    }, [value, setValue]);

    const provider =
        areaId && providerId ? getProvider(areaId, providerId) : undefined;

    if (!provider || provider.plans === null) {
        return null;
    }

    const selectedPlan = value ? getPlan(provider, value) : undefined;

    return (
        <Select
            label="プラン"
            required
            name={name}
            value={value ?? ''}
            onChange={(event) => {
                onChange(event.target.value || null);
            }}
            onBlur={onBlur}
            error={value !== null ? errors.planId?.message : undefined}
            helpText={selectedPlan?.description ?? undefined}
            options={provider.plans.map((plan) => ({
                label: plan.name,
                value: plan.id,
            }))}
        />
    );
}
