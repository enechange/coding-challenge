import { masterData } from './master-data';
import type { AreaId, Plan, Provider } from './types';

export function getProviders(areaId: AreaId): Provider[] {
    return masterData[areaId].providers;
}

export function getProvider(
    areaId: AreaId,
    providerId: string,
): Provider | undefined {
    return getProviders(areaId).find((provider) => provider.id === providerId);
}

export function getPlan(provider: Provider, planId: string): Plan | undefined {
    return provider.plans?.find((plan) => plan.id === planId);
}
