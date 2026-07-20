'use client';

import { useEffect } from 'react';
import { useController, useFormContext, useWatch } from 'react-hook-form';

import { Select } from '@/components/ui/form';

import { SIMULATION_NOT_SUPPORTED_MESSAGE } from '../data/constants';
import { getProvider, getProviders } from '../data/selectors';
import type { SimulationFormInput } from '../schemas/simulation-form-schema';

export function ProviderSelect() {
    const {
        control,
        setValue,
        formState: { errors },
    } = useFormContext<SimulationFormInput>();
    const areaId = useWatch({ control, name: 'areaId' });
    const {
        field: { value, onChange, onBlur, name },
    } = useController({ control, name: 'providerId' });

    useEffect(() => {
        setValue('providerId', null);
        setValue('planId', null);
        setValue('capacityValue', null);
        // areaId が変わるたびに下流（電力会社以降）をリセットする
    }, [areaId, setValue]);

    if (!areaId) {
        return null;
    }

    const providers = getProviders(areaId);
    const selectedProvider = value ? getProvider(areaId, value) : undefined;

    return (
        <Select
            label="電力会社"
            required
            name={name}
            value={value ?? ''}
            onChange={(event) => {
                onChange(event.target.value || null);
            }}
            onBlur={onBlur}
            error={
                // Selectは変更した瞬間に確定するため、blur済みかどうかではなく
                // 値が選択済みかどうかでエラー表示を判定する
                value !== null
                    ? selectedProvider?.plans === null
                        ? SIMULATION_NOT_SUPPORTED_MESSAGE
                        : errors.providerId?.message
                    : undefined
            }
            options={providers.map((provider) => ({
                label: provider.name,
                value: provider.id,
            }))}
        />
    );
}
