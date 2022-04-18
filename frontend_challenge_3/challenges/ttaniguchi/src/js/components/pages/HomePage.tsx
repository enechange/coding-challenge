import React, { FC, useCallback, useEffect, useState } from 'react';
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
  const [data, setData] = useState<Area | undefined>(undefined);
  const [dialog, handleDialog] = useState<Dialog | undefined>(undefined);

  const [code, handleCode] = useState<[string, string]>(['', '']);
  const [corpId, handleCorpId] = useState<number | undefined>(undefined);
  const [planId, handlePlanId] = useState<number | undefined>(undefined);
  const [capId, handleCapId] = useState<number | undefined>(undefined);
  const [cost, handleCost] = useState<number | undefined>(undefined);

  const areaId = code[0].slice(0, 1);
  useEffect(() => {
    if (areaId) {
      const url = `/api/areas/${areaId}.json`;
      fetch(url)
        .then((r) => r.json())
        .then(({ data }) => setData(data));
    }
  }, [areaId]);

  const corp = data?.corporations.find((r) => r.id === corpId);
  const corpList = data?.corporations.map(({ id, name }) => ({
    key: id,
    value: name,
  }));

  const plan = corp?.plans.find((r) => r.id === planId);
  const planList = corp?.plans.map(({ id, name }) => ({
    key: id,
    value: name,
  }));

  const capList = plan?.capacity.map((row, i) => ({
    key: i + 1,
    value: row,
  }));
  const cap = capList?.find((r) => r.key === capId);

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
    [data, corpList, planList, capList],
  );

  return (
    <StyledRoot>
      <FormTemplate
        code={code}
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
            onSelect={dialog.onSelect}
          />
        </DialogLayout>
      )}
    </StyledRoot>
  );
};
export default HomePage;
