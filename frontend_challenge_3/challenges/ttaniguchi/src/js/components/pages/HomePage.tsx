import React, { FC, useCallback, useEffect, useState } from 'react';
import styled from 'styled-components';
import DialogTemplate from '@/js/components/templates/DialogTemplate';
import FormTemplate, { SelectorType } from '@/js/components/templates/FormTemplate';
import useSelectableList from '@/js/customHooks/useSelectableList';
import { Area } from '@/js/types/Area';
import { List } from '@/js/types/List';

const StyledRoot = styled.div`
  display: flex;
  justify-content: center;
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
  const [corpId, handleCorpId] = useState<number | undefined>(undefined);
  const [planId, handlePlanId] = useState<number | undefined>(undefined);
  const [capId, handleCapId] = useState<number | undefined>(undefined);
  const [cost, handleCost] = useState<number | undefined>(undefined);
  const [email, handleEmail] = useState<string | undefined>(undefined);

  const areaId = code[0].slice(0, 1);
  useEffect(() => {
    handleCorpId(undefined);
    if (areaId) {
      const url = `/api/areas/${areaId}.json`;
      fetch(url)
        .then((r) => r.json())
        .then(({ data }) => setAreaData(data))
        .catch(() => setAreaData(undefined));
    }
  }, [areaId]);

  const { corp, plan, cap, selectableCorps, selectablePlans, selectableCaps } =
    useSelectableList({
      areaData,
      corpId,
      planId,
      capId,
    });

  useEffect(() => {
    handlePlanId(undefined);
  }, [areaData?.corporations, corpId]);

  useEffect(() => {
    handleCapId(undefined);
    if (planId && !selectableCaps?.length) {
      handleCapId(0);
    }
  }, [corp?.plans, planId]);

  const close = useCallback((callback?: () => void) => {
    if (callback) {
      callback();
    }
    handleDialog(undefined);
  }, []);

  const open = useCallback(
    (key: SelectorType) => {
      if (key === 'corp' && selectableCorps) {
        handleDialog({
          list: selectableCorps,
          selected: corpId,
          onSelect: (key) => close(() => handleCorpId(key)),
        });
      }
      if (key === 'plan' && selectablePlans) {
        handleDialog({
          list: selectablePlans,
          selected: planId,
          onSelect: (key) => close(() => handlePlanId(key)),
        });
      }
      if (key === 'cap' && selectableCaps) {
        handleDialog({
          list: selectableCaps,
          selected: capId,
          onSelect: (key) => close(() => handleCapId(key)),
        });
      }
    },
    [areaData, selectableCorps, selectablePlans, selectableCaps],
  );

  const handleSend = useCallback(() => {
    const results = [
      `郵便番号: ${code.join('-')}`,
      `電力会社: ${corp?.name}`,
      `プラン: ${plan?.name}`,
      `契約容量: ${cap?.value || '─'}`,
      `電気代: ${cost}円`,
      `メール: ${email}`,
    ];

    handleDialog({
      list: results.map((value, key) => ({ key, value })),
      selected: capId,
      onSelect: () => close(),
    });
  }, [code, corp, plan, cap, cost, email]);

  return (
    <StyledRoot>
      <FormTemplate
        code={code}
        areaData={areaData}
        corpId={corpId}
        planId={planId}
        capId={capId}
        cost={cost}
        email={email}
        handleCode={handleCode}
        openDialog={open}
        handleCost={handleCost}
        handleEmail={handleEmail}
        handleSend={handleSend}
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
