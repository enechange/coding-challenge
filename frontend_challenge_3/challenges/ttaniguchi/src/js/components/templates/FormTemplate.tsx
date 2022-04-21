import React, { FC, useCallback, useMemo, useState } from 'react';
import styled from 'styled-components';
import ExecButton from '@/js/components/molecules/ExecButton';
import PostalForm from '@/js/components/organisms/PostalForm';
import SelectForm, { Selector } from '@/js/components/organisms/SelectForm';
import CostForm from '@/js/components/organisms/CostForm';
import EmailForm from '@/js/components/organisms/EmailForm';
import useSelectableList from '@/js/customHooks/useSelectableList';
import { isEmail } from '@/js/libs/valid';
import { Area } from '@/js/types/Area';

const StyledRoot = styled.div`
  max-width: var(--body-width);
  position: relative;
  width: 100%;
`;
const StyledJumbotron = styled.div`
  font-size: 16px;
  line-height: 20px;
  padding: 16px 0 24px;
  text-align: center;
`;
const StyledTopic = styled.div`
  font-size: 20px;
  font-weight: bold;
  letter-spacing: 0.15em;
  line-height: 28px;
  padding: 16px 0;
`;
const ContainerLayout = styled.div`
  padding: 16px 0;
`;
const ButtonLayout = styled.div`
  padding: 24px;
`;
const unselected = '- 未選択 -' as const;

export type Props = {
  code: [string, string];
  areaData?: Area;
  corpId?: number;
  planId?: number;
  capId?: number;
  cost?: number;
  email?: string;
  handleCode: (code: [string, string]) => void;
  openDialog: (type: string) => void;
  handleCost: (cost: number) => void;
  handleEmail: (email: string) => void;
  handleSend: () => void;
};
const FormTemplate: FC<Props> = ({
  code,
  areaData,
  corpId,
  planId,
  capId,
  cost,
  email,
  handleCode,
  openDialog,
  handleCost,
  handleEmail,
  handleSend,
}) => {
  const [blurCost, handleBlurCost] = useState(false);
  const [blurEmail, handleBlurEmail] = useState(false);
  const { corp, plan, cap, selectableCaps } = useSelectableList({
    areaData,
    corpId,
    planId,
    capId,
  });

  const errors: Record<string, boolean> = useMemo(
    () => ({
      ngCode: code.join('').length !== 7,
      noCorpId: corpId === undefined,
      noPlanId: planId === undefined,
      noCapId: capId === undefined,
      noCost: cost === undefined,
      noEmail: email === undefined,
      ngCost: !!(blurCost && cost && cost < 1000),
      ngEmail: !!(blurEmail && email && !isEmail(email)),
      outOfArea: !areaData && code.join('').length === 7,
      outOfSimulation: !!(corp && corp.plans.length === 0),
    }),
    [!!areaData, code, corpId, planId, capId, cost, blurCost, email, blurEmail],
  );
  const hasError = Object.values(errors).some((r) => r);
  const notNeedCap = plan && selectableCaps?.length === 0;

  const selector: Selector[] = [
    {
      name: '電力会社',
      selected: corp?.name,
      disabled: !areaData,
      handler: () => openDialog('corp'),
    },
    {
      name: 'プラン',
      selected: plan ? plan.name : unselected,
      description: plan ? plan.description : undefined,
      disabled: !corp,
      handler: errors.outOfSimulation ? undefined : () => openDialog('plan'),
    },
    {
      name: '契約容量',
      selected: cap?.value || unselected,
      disabled: !plan,
      handler:
        errors.outOfSimulation || notNeedCap
          ? undefined
          : () => openDialog('cap'),
    },
  ];

  const handleOnSend = useCallback(() => {
    if (!hasError) {
      handleSend();
    }
  }, [errors]);

  return (
    <StyledRoot>
      <StyledJumbotron>
        <StyledTopic>
          電気代から
          <br />
          かんたんシミュレーション
        </StyledTopic>
        <div>
          検針票を用意しなくてもOK
          <br />
          いくらおトクになるのか今すぐわかります！
        </div>
      </StyledJumbotron>
      <ContainerLayout>
        <PostalForm
          code={code}
          error={errors.outOfArea ? 'サービスエリア対象外です。' : undefined}
          onChange={handleCode}
        />
      </ContainerLayout>
      <ContainerLayout>
        <SelectForm
          selectors={selector}
          error={
            errors.outOfSimulation ? 'シミュレーション対象外です。' : undefined
          }
        />
      </ContainerLayout>
      <ContainerLayout>
        <CostForm
          cost={cost}
          error={errors.ngCost ? '電気代を正しく入力してください。' : undefined}
          onBlur={() => handleBlurCost(true)}
          onChange={handleCost}
        />
      </ContainerLayout>
      <ContainerLayout>
        <EmailForm
          email={email}
          error={
            errors.ngEmail
              ? 'メールアドレスを正しく入力してください。'
              : undefined
          }
          onBlur={() => handleBlurEmail(true)}
          onChange={handleEmail}
        />
      </ContainerLayout>
      <ButtonLayout>
        <ExecButton onClick={handleOnSend} disabled={hasError} />
      </ButtonLayout>
    </StyledRoot>
  );
};
export default FormTemplate;
