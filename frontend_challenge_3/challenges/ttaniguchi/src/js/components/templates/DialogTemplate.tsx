import React, { FC, useEffect } from 'react';
import styled from 'styled-components';
import ListForm from '@/js/components/organisms/ListForm';
import { List } from '@/js/types/List';

const StyledRoot = styled.div`
  align-items: center;
  background: var(--body-overlay);
  display: flex;
  height: 100vh;
  justify-content: center;
  position: relative;

  animation: fade-in 0.25s ease-out;
  animation-direction: normal;
`;
const DialogLayout = styled.div`
  height: 100vh;
  max-width: var(--body-width);
  padding: 48px 16px;
  width: 100%;
`;

export type Props = {
  list: List;
  selected?: number;
  onClose: () => void;
  onSelect: (key: number) => void;
};
const DialogTemplate: FC<Props> = ({ list, selected, onClose, onSelect }) => {
  useEffect(() => {
    document.body.style.overflow = 'hidden';

    return () => {
      document.body.style.overflow = '';
    };
  }, []);

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
