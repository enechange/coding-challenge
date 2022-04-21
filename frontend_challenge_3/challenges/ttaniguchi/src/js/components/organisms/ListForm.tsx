import React, { FC } from 'react';
import styled from 'styled-components';
import { List } from '@/js/types/List';

const StyledRoot = styled.div`
  background: var(--white);
  border-radius: 16px;
  height: 100%;
  min-height: 240px;
  padding: 48px 0;

  animation: fade-in 0.25s ease-out;
  animation: move-up 0.25s ease-out;
  animation-direction: normal;
`;
const StyledList = styled.div`
  border-top: 1px solid var(--black);
  border-bottom: 1px solid var(--black);
  height: 100%;
  overflow-y: scroll;
`;
const StyledData = styled.div<{ selected: boolean }>`
  ${({ selected }) =>
    selected &&
    `
    background: var(--body-selected);
  `}
  align-items: center;
  border-top: 1px solid var(--line-default);
  display: flex;
  height: 64px;
  padding: 0 16px;
  &:first-child {
    border-bottom: 0;
  }
  &:hover,
  &:focus {
    background: var(--body-active);
  }
`;

export type Props = {
  list: List;
  selected?: number;
  onSelect: (key: number) => void;
};
const SelectForm: FC<Props> = ({ list, selected, onSelect }) => {
  return (
    <StyledRoot onClick={(e) => e.stopPropagation()}>
      <StyledList>
        {list.map(({ key, value }) => (
          <StyledData
            key={key}
            selected={key === selected}
            onClick={(e) => {
              e.stopPropagation();
              onSelect(key);
            }}
          >
            {value}
          </StyledData>
        ))}
      </StyledList>
    </StyledRoot>
  );
};
export default SelectForm;
