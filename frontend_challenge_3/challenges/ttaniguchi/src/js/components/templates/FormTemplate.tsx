import React, { FC, useState } from 'react';
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

const FormTemplate: FC = () => {
  const [code, handleCode] = useState<[string, string]>(['', '']);
  // const [corp, handleCorp] = useState<string>('');
  // const [plan, handlePlan] = useState<[string, string]>(['', '']);
  // const [cap, handleCap] = useState<number>(0);
  const [cost, handleCost] = useState<number | undefined>(undefined);

  // TODO: 暫定データ
  const [corp, plan, cap] = [
    '東京電力エナジーパートナー',
    ['従量灯C', '従量灯Cプランです'],
    49,
  ];

  const open = () => {
    console.log('clicked');
  };

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
          onClickCorp={open}
          onClickPlan={open}
          onClickCap={open}
        />
      </ContainerLayout>
      <ContainerLayout>
        <CostForm cost={cost} onChange={handleCost} />
      </ContainerLayout>
      <ButtonLayout>
        <ExecButton onClick={() => console.log('onClick')} disabled={false} />
      </ButtonLayout>
    </StyledRoot>
  );
};
export default FormTemplate;
