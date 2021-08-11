import React, { useCallback } from 'react';
import styled from 'styled-components';
import { Colors } from '../assets/Colors';
import Icon from '../assets/svgIcons';

const Wrapper = styled.div`
  display: flex;
  position: relative;
  box-sizing: border-box;
  height: 110px;
  overflow: hidden;
  border: ${Colors.gray} 8px solid;
  border-radius: 4px;
  pointer-events: ${(props) => props.isActive ? "auto" : "none"};
  opacity: ${(props) => props.isActive ? "1" : "0.5"};
`;

const PullDownSelect = styled.select`
  box-sizing: border-box;
  width: 100%;
  padding: 0 40px 0 90px;
  border: none;
  cursor: pointer;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  font-size: 25px;
`;

const IconWrapper = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  width: 80px;
  pointer-events: none;
`;

const SelectBox = props => {
  const { className, items, selectedValue, isActive, onSelect } = props;

  return (
    <Wrapper className={className} isActive={isActive}>
      <IconWrapper>
        <Icon.DownArrow width={60} height={60} color={Colors.orange} />
      </IconWrapper>
      <PullDownSelect onChange={onSelect} value={selectedValue}>
        <option value="default">選んでください</option>
        {items.map((item, index) => {
          const name = item.name ?? item;
          return (
            <option key={index} value={name}>
              {name}
            </option>
          )
        })}
      </PullDownSelect>
    </Wrapper>
  );
};
export default SelectBox;
