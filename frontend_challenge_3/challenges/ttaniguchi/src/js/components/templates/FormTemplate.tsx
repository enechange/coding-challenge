import React, { FC } from 'react';
import styled from 'styled-components';
import ExecButton from '@/js/components/molecules/ExecButton';
import PostalForm from '@/js/components/organisms/PostalForm';
import SelectForm from '@/js/components/organisms/SelectForm';
import CostForm from '@/js/components/organisms/CostForm';

const StyledRoot = styled.div`
  position: relative;
`;
const ContainerLayout = styled.div`
  padding: 16px 0;
`;
const ButtonLayout = styled.div`
  padding: 24px;
`;

export type Props = {
  code: [string, string];
  corp?: string;
  plan?: [string, string];
  cap?: number;
  cost?: number;
  handleCode: (code: [string, string]) => void;
  openDialog: (type: string) => void;
  handleCost: (cap: number) => void;
  handleSend: () => void;
};
const FormTemplate: FC<Props> = ({
  code,
  corp,
  plan,
  cap,
  cost,
  handleCode,
  openDialog,
  handleCost,
  handleSend,
}) => {
  return (
    <StyledRoot>
      <div>
        <div>電気代から かんたんシミュレーション</div>
        <div>
          検針票を用意しなくてもOK いくらおトクになるのか今すぐわかります！
        </div>
      </div>
      <ContainerLayout>
        <PostalForm code={code} onChange={handleCode} />
      </ContainerLayout>
      <ContainerLayout>
        <SelectForm
          selectedCorp={corp}
          selectedPlan={plan as [string, string]}
          selectedCap={cap}
          onClickCorp={() => openDialog('corp')}
          onClickPlan={() => openDialog('plan')}
          onClickCap={() => openDialog('cap')}
        />
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
