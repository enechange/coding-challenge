import { useMemo } from 'react';
import { Area } from '@/js/types/Area';

const useSelectableList = ({
  areaData,
  corpId,
  planId,
  capId,
}: {
  areaData?: Area;
  corpId?: number;
  planId?: number;
  capId?: number;
}) => {
  const [corp, selectableCorps] = useMemo(() => {
    return areaData?.corporations
      ? [
          areaData.corporations.find((r) => r.id === corpId),
          areaData.corporations.map(({ id, name }) => ({
            key: id,
            value: name,
          })),
        ]
      : [];
  }, [areaData?.corporations, corpId]);

  const [plan, selectablePlans] = useMemo(() => {
    return corp?.plans
      ? [
          corp.plans.find((r) => r.id === planId),
          corp.plans.map(({ id, name }) => ({ key: id, value: name })),
        ]
      : [];
  }, [corp?.plans, planId]);

  const [cap, selectableCaps] = useMemo(() => {
    const selectableCaps = plan?.capacity.map((value, i) => ({
      key: i + 1,
      value,
    }));
    const cap = selectableCaps?.find((r) => r.key === capId);
    return [cap, selectableCaps];
  }, [plan?.capacity, capId]);

  return {
    corp,
    plan,
    cap,
    selectableCorps,
    selectablePlans,
    selectableCaps,
  };
};

export default useSelectableList;
