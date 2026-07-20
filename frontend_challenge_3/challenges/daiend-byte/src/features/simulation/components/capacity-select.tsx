'use client';

import { useController, useFormContext, useWatch } from 'react-hook-form';

import { Select } from '@/components/ui/form';
import { Reveal } from '@/components/ui/reveal';

import { getPlan, getProvider } from '../data/selectors';
import type { SimulationFormInput } from '../schemas/simulation-form-schema';

export function CapacitySelect() {
    const {
        control,
        formState: { errors },
    } = useFormContext<SimulationFormInput>();
    const areaId = useWatch({ control, name: 'areaId' });
    const providerId = useWatch({ control, name: 'providerId' });
    const planId = useWatch({ control, name: 'planId' });
    const {
        field: { value, onChange, onBlur, name },
    } = useController({ control, name: 'capacityValue' });

    const provider =
        areaId && providerId ? getProvider(areaId, providerId) : undefined;
    const plan = provider && planId ? getPlan(provider, planId) : undefined;

    if (!plan || plan.capacities === null) {
        return null;
    }

    return (
        <Reveal>
            <Select
                label="契約容量"
                required
                name={name}
                value={value ?? ''}
                onChange={(event) => {
                    onChange(event.target.value || null);
                }}
                onBlur={onBlur}
                error={
                    value !== null ? errors.capacityValue?.message : undefined
                }
                options={plan.capacities.map((capacity) => ({
                    label: capacity,
                    value: capacity,
                }))}
            />
        </Reveal>
    );
}
