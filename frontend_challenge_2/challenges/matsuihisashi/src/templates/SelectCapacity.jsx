import React from "react";
import styled from 'styled-components'
import SubCaption from '../components/SubCaption';
import ErrorMessage from "../components/ErrorMessage";
import SelectBox from "../components/SelectBox";
import { Colors } from '../assets/Colors'

const Wrapper = styled.div`
  width: 90%;
  margin: 48px auto 12px;
`;

const StyledSelectBox = styled(SelectBox)`
  margin: 12px 0;
`;

const SelectCapacity = props => {
  const { onSelect, planList, isActive, selectedPlan, selectedPlanDescription } = props;

  return (
    <Wrapper>
      <SubCaption labelText="必 須" captionText="契約容量" />
      <StyledSelectBox items={planList} isActive={isActive} onSelect={onSelect} selectedValue={selectedPlan} />
      {selectedPlanDescription !== "" && <ErrorMessage innerText={selectedPlanDescription} />}
    </Wrapper>
  );
}
export default SelectCapacity;
