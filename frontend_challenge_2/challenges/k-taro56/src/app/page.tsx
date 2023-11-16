'use client';

import { useState } from 'react';
import styled from '@emotion/styled';

const Container = styled.div`
  min-height: 100vh;
  margin-left: auto;
  margin-right: auto;

  @media (min-width: 640px) { /* sm */
    max-width: 640px;
  }

  @media (min-width: 768px) { /* md */
    max-width: 768px;
  }

  @media (min-width: 1024px) { /* lg */
    max-width: 1024px;
  }

  @media (min-width: 1280px) { /* xl */
    max-width: 1280px;
  }

  @media (min-width: 1536px) { /* 2xl */
    max-width: 1536px;
  }

  align-items: center;
  justify-content: center;
  @media (min-width: 640px) {
    padding-top: 0px;
    padding-bottom: 3rem;
    padding-right: 1.5rem;
    padding-left: 1.5rem;
  }
  @media (min-width: 1024px) {
    padding-top: 0px;
    padding-bottom: 3rem;
    padding-right: 2rem;
    padding-left: 2rem;
  }
  .dark & {
    background-color: #1a202c;F
  }
`;

const Title = styled.h1`
  color: #333;
  text-align: center;
`;

const SubTitle = styled.h2`
  color: #666;
  text-align: center;
`;

const InputGroup = styled.div`
  margin-bottom: 20px;
`;

const Label = styled.label`
  display: block;
  margin-bottom: 5px;
  color: #666;
`;

const Input = styled.input`
  width: 100%;
  padding: 10px;
  margin-bottom: 5px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-sizing: border-box;
`;

const CheckboxLabel = styled.label`
  display: flex;
  align-items: center;
  color: #666;
`;

const Checkbox = styled.input`
  margin-right: 10px;
`;

const Button = styled.button`
  width: 100%;
  padding: 15px;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  color: white;
  font-size: 16px;
  cursor: pointer;
  &:hover {
    background-color: #0056b3;
  }
`;

const Home = () => {
  const [postalCode, setPostalCode] = useState('');
  const [isTokyoEnergyPartner, setIsTokyoEnergyPartner] = useState(true);
  const [isTodenETC, setIsTodenETC] = useState(true);
  const [contractCapacity, setContractCapacity] = useState('');
  const [currentUsage, setCurrentUsage] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log({
      postalCode,
      isTokyoEnergyPartner,
      isTodenETC,
      contractCapacity,
      currentUsage,
    });
  };

  return (
    <Container>
      <Title>
        電気代から
        <br />
        かんたんシミュレーション
      </Title>
      <SubTitle>
        検針票を用意しなくても OK
        <br />
        いくらおトクになるのか今すぐわかります！
      </SubTitle>
      <form onSubmit={handleSubmit}>
        <InputGroup>
          <Label>電気を使用する場所の郵便番号</Label>
          <Input
            type='text'
            placeholder='130 - 0012'
            value={postalCode}
            onChange={(e) => setPostalCode(e.target.value)}
          />
        </InputGroup>

        <InputGroup>
          <CheckboxLabel>
            <Checkbox
              type='checkbox'
              checked={isTokyoEnergyPartner}
              onChange={(e) => setIsTokyoEnergyPartner(e.target.checked)}
            />
            東京電力エナジーパートナー
          </CheckboxLabel>
        </InputGroup>

        <InputGroup>
          <CheckboxLabel>
            <Checkbox
              type='checkbox'
              checked={isTodenETC}
              onChange={(e) => setIsTodenETC(e.target.checked)}
            />
            東電eネ!TC
          </CheckboxLabel>
        </InputGroup>

        <InputGroup>
          <Label>契約容量</Label>
          <Input
            type='text'
            placeholder='49kVA'
            value={contractCapacity}
            onChange={(e) => setContractCapacity(e.target.value)}
          />
        </InputGroup>

        <InputGroup>
          <Label>現在の電気の使用状況について教えてください</Label>
          <Input
            type='text'
            placeholder='5000'
            value={currentUsage}
            onChange={(e) => setCurrentUsage(e.target.value)}
          />
        </InputGroup>

        <Button type='submit'>結果を見る</Button>
      </form>
    </Container>
  );
};

export default Home;
