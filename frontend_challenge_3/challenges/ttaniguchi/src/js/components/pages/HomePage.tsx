import React, { FC, useCallback, useEffect, useState } from 'react';
import styled from 'styled-components';
import DialogTemplate from '@/js/components/templates/DialogTemplate';
import FormTemplate from '@/js/components/templates/FormTemplate';
import { Area } from '@/js/types/Area';
import { List } from '@/js/types/List';

const StyledRoot = styled.div`
  position: relative;
`;
const DialogLayout = styled.div`
  height: 100vh;
  left: 0;
  position: fixed;
  top: 0;
  width: 100%;
`;

const HomePage: FC = () => {
  const [data, setData] = useState<Area | undefined>(undefined);
  const [code, handleCode] = useState<[string, string]>(['', '']);
  const [corp, handleCorp] = useState<string | undefined>(undefined);
  const [plan, handlePlan] = useState<[string, string] | undefined>(undefined);
  const [cap, handleCap] = useState<number | undefined>(undefined);
  const [cost, handleCost] = useState<number | undefined>(undefined);

  const [dialog, handleDialog] = useState<
    | {
        list: List;
        selected: number;
        onSelect: (key: number) => void;
      }
    | undefined
  >(undefined);

  const id = code[0].slice(0, 1);
  useEffect(() => {
    if (id) {
      const url = `/api/areas/${id}.json`;
      fetch(url)
        .then((r) => r.json())
        .then(({ data }) => setData(data));
    }
  }, [id]);

  const close = useCallback(() => {
    handleDialog(undefined);
  }, []);
  const open = useCallback(
    (key: string) => {
      switch (key) {
        case 'corp':
          if (data?.corporations) {
            handleDialog({
              list: [{ key: 1, value: '東京電力' }],
              selected: 1,
              onSelect: () => {
                handleCorp('東京電力');
                close();
              },
            });
          }
          break;
        case 'plan':
          handleDialog({
            list: [{ key: 1, value: '従量電灯C' }],
            selected: 1,
            onSelect: () => {
              handlePlan(['従量電灯C', '従量電灯Cプランです']);
              close();
            },
          });
          break;
        case 'cap':
          handleDialog({
            list: [{ key: 1, value: '49kVA' }],
            selected: 1,
            onSelect: () => {
              handleCap(49);
              close();
            },
          });
          break;
        default:
          break;
      }
    },
    [data],
  );

  return (
    <StyledRoot>
      <FormTemplate
        code={code}
        corp={corp}
        plan={plan}
        cap={cap}
        cost={cost}
        handleCode={handleCode}
        openDialog={open}
        handleCost={handleCost}
        handleSend={() => console.log('sending')}
      />
      {dialog && (
        <DialogLayout>
          <DialogTemplate
            list={dialog.list}
            selected={dialog.selected}
            onSelect={dialog.onSelect}
          />
        </DialogLayout>
      )}
    </StyledRoot>
  );
};
export default HomePage;
