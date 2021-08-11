import React from "react";
import styled from 'styled-components'
import SubCaption from '../components/SubCaption';
import SelectBox from "../components/SelectBox";

const Wrapper = styled.div`
  width: 92%;
  margin: 48px auto 12px;
`;

const StyledSelectBox = styled(SelectBox)`
  margin: 12px 0;
`;

const SelectCapacity = props => {
  const { onSelect, capacityList, isActive, selectedCapacity } = props;

  return (
    <Wrapper>
      <SubCaption labelText="必 須" captionText="契約容量" />
      <StyledSelectBox items={capacityList} isActive={isActive} onSelect={onSelect} selectedValue={selectedCapacity} />
    </Wrapper>
  );
}
export default SelectCapacity;
