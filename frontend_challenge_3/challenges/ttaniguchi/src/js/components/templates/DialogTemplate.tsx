import React, { FC } from 'react';
import styled from 'styled-components';
import ListForm from '@/js/components/organisms/ListForm';
import { List } from '@/js/types/List';

const StyledRoot = styled.div`
  align-items: center;
  background: var(--body-overlay);
  display: flex;
  height: 100vh;
  position: relative;
`;
const DialogLayout = styled.div`
  height: 70vh;
  padding: 0 16px;
  width: 100%;
`;

export type Props = {
  list: List;
  selected?: number;
  onClose: () => void;
  onSelect: (key: number) => void;
};
const DialogTemplate: FC<Props> = ({ list, selected, onClose, onSelect }) => {
  return (
    <StyledRoot
      onClick={(e) => {
        e.stopPropagation();
        onClose();
      }}
    >
      <DialogLayout>
        <ListForm list={list} selected={selected} onSelect={onSelect} />
      </DialogLayout>
    </StyledRoot>
  );
};
export default DialogTemplate;
