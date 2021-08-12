import React from "react";
import styled from 'styled-components';
import SubCaption from '../components/SubCaption';
import ErrorMessage from "../components/ErrorMessage";
import SelectBox from "../components/SelectBox";

const Wrapper = styled.div`
  width: 92%;
  margin: 48px auto 12px;
`;

const StyledSelectBox = styled(SelectBox)`
  margin: 12px 0;
`;

const SelectElectricPowerCompany = props => {
  const { onSelect, companiesList, isUnsimulatable, isActive, selectedCompany } = props;
  return (
    <Wrapper>
      <SubCaption labelText="必 須" captionText="電力会社" />
      <StyledSelectBox items={companiesList} isActive={isActive} onSelect={onSelect} selectedValue={selectedCompany} />
      {isUnsimulatable && <ErrorMessage innerText="シミュレーション対象外です。" />}
    </Wrapper>
  );
};

export default SelectElectricPowerCompany;
