import React, { FC } from 'react';
import styled from 'styled-components';
import ExecButton from '@/js/components/molecules/ExecButton';
import PostalForm from '@/js/components/organisms/PostalForm';
import SelectForm, { Selector } from '@/js/components/organisms/SelectForm';
import CostForm from '@/js/components/organisms/CostForm';
import { Area } from '@/js/types/Area';

const StyledRoot = styled.div`
  position: relative;
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

export type Props = {
  code: [string, string];
  areaData?: Area;
  corp?: string;
  plan?: [string, string];
  cap?: string;
  cost?: number;
  handleCode: (code: [string, string]) => void;
  openDialog: (type: string) => void;
  handleCost: (cost: number) => void;
  handleSend: () => void;
};
const FormTemplate: FC<Props> = ({
  code,
  areaData,
  corp,
  plan,
  cap,
  cost,
  handleCode,
  openDialog,
  handleCost,
  handleSend,
}) => {
  const unselected = '- 未選択 -' as const;
  const selector: Selector[] = [
    {
      name: '電力会社',
      selected: corp || unselected,
      disabled: code.join('').length < 7 || !areaData,
      handler: () => openDialog('corp'),
    },
    {
      name: 'プラン',
      selected: plan ? plan[0] : unselected,
      description: plan ? plan[1] : undefined,
      disabled: !corp,
      handler: () => openDialog('plan'),
    },
    {
      name: '契約容量',
      selected: cap || unselected,
      disabled: !plan,
      handler: () => openDialog('cap'),
    },
  ];

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
        <PostalForm code={code} onChange={handleCode} />
      </ContainerLayout>
      <ContainerLayout>
        <SelectForm selectors={selector} />
      </ContainerLayout>
      <ContainerLayout>
        <CostForm cost={cost} onChange={handleCost} />
      </ContainerLayout>
      <ButtonLayout>
        <ExecButton onClick={handleSend} disabled={false} />
      </ButtonLayout>
    </StyledRoot>
  );
};
export default FormTemplate;
