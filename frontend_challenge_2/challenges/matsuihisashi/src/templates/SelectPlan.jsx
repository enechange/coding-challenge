import React from "react";
import styled from 'styled-components';
import SubCaption from '../components/SubCaption';
import Description from "../components/Description";
import SelectBox from "../components/SelectBox";

const Wrapper = styled.div`
  width: 92%;
  margin: 48px auto 12px;
`;

const StyledSelectBox = styled(SelectBox)`
  margin: 12px 0 2px 0;
`;

const SelectPlan = props => {
  const { onSelect, planList, isActive, selectedPlan, selectedPlanDescription } = props;

  return (
    <Wrapper>
      <SubCaption labelText="必 須" captionText="プラン" />
      <StyledSelectBox items={planList} isActive={isActive} onSelect={onSelect} selectedValue={selectedPlan} />
      {selectedPlanDescription !== "" && <Description innerText={selectedPlanDescription} />}
    </Wrapper>
  );
};

export default SelectPlan;
