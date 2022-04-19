import React, { FC, useCallback, useEffect, useMemo, useState } from 'react';
import styled from 'styled-components';
import DialogTemplate from '@/js/components/templates/DialogTemplate';
import FormTemplate from '@/js/components/templates/FormTemplate';
import { Area } from '@/js/types/Area';
import { List } from '@/js/types/List';

const StyledRoot = styled.div`
  position: relative;
`;
const DialogLayout = styled.div`
  height: 100vh;
  left: 0;
  position: fixed;
  top: 0;
  width: 100%;
`;

type Dialog = {
  list: List;
  selected: number | undefined;
  onSelect: (key: number) => void;
};

const HomePage: FC = () => {
  const [areaData, setAreaData] = useState<Area | undefined>(undefined);
  const [dialog, handleDialog] = useState<Dialog | undefined>(undefined);

  const [code, handleCode] = useState<[string, string]>(['', '']);
  const [corpId, handleCorpId] = useState<number>(0);
  const [planId, handlePlanId] = useState<number>(0);
  const [capId, handleCapId] = useState<number>(0);
  const [cost, handleCost] = useState<number | undefined>(undefined);

  const areaId = code[0].slice(0, 1);
  useEffect(() => {
    handleCorpId(0);
    if (areaId) {
      const url = `/api/areas/${areaId}.json`;
      fetch(url)
        .then((r) => r.json())
        .then(({ data }) => setAreaData(data));
    }
  }, [areaId]);

  const [corp, corpList] = useMemo(() => {
    handlePlanId(0);
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

  const [plan, planList] = useMemo(() => {
    handleCapId(0);
    return corp?.plans
      ? [
          corp.plans.find((r) => r.id === planId),
          corp.plans.map(({ id, name }) => ({ key: id, value: name })),
        ]
      : [];
  }, [corp?.plans, planId]);

  const [cap, capList] = useMemo(() => {
    const capList = plan?.capacity.map((value, i) => ({ key: i + 1, value }));
    const cap = capList?.find((r) => r.key === capId);
    return [cap, capList];
  }, [plan?.capacity, capId]);

  const close = useCallback((callback?: () => void) => {
    if (callback) {
      callback();
    }
    handleDialog(undefined);
  }, []);

  const open = useCallback(
    (key: string) => {
      if (key === 'corp' && corpList) {
        handleDialog({
          list: corpList,
          selected: corpId,
          onSelect: (key) => close(() => handleCorpId(key)),
        });
      }
      if (key === 'plan' && planList) {
        handleDialog({
          list: planList,
          selected: planId,
          onSelect: (key) => close(() => handlePlanId(key)),
        });
      }
      if (key === 'cap' && capList) {
        handleDialog({
          list: capList,
          selected: capId,
          onSelect: (key) => close(() => handleCapId(key)),
        });
      }
    },
    [areaData, corpList, planList, capList],
  );

  return (
    <StyledRoot>
      <FormTemplate
        code={code}
        areaData={areaData}
        corp={corp?.name}
        plan={plan && [plan.name, plan.description]}
        cap={cap?.value}
        cost={cost}
        handleCode={handleCode}
        openDialog={open}
        handleCost={handleCost}
        handleSend={() => console.log('sending')}
      />
      {dialog && (
        <DialogLayout>
          <DialogTemplate
            list={dialog.list}
            selected={dialog.selected}
            onClose={() => close()}
            onSelect={dialog.onSelect}
          />
        </DialogLayout>
      )}
    </StyledRoot>
  );
};
export default HomePage;
