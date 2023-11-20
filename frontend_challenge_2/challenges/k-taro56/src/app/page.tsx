'use client';

import { useState } from 'react';
import styled from '@emotion/styled';

import Header from '@/components/header';
import FormGroups from '@/components/form-groups';
import PostCodeForm from '@/components/form-containers/post-code';

const Container = styled.div`
  margin-left: auto;
  margin-right: auto;

  @media (min-width: 640px) {
    /* sm */
    max-width: 640px;
  }

  @media (min-width: 768px) {
    /* md */
    max-width: 768px;
  }

  @media (min-width: 1024px) {
    /* lg */
    max-width: 1024px;
  }

  @media (min-width: 1280px) {
    /* xl */
    max-width: 1280px;
  }

  @media (min-width: 1536px) {
    /* 2xl */
    max-width: 1536px;
  }

  align-items: center;
  justify-content: center;

  @media (min-width: 640px) {
    padding-top: 0;
    padding-bottom: 0;
    padding-right: 1.5rem;
    padding-left: 1.5rem;
  }
  @media (min-width: 1024px) {
    padding-top: 0;
    padding-bottom: 0;
    padding-right: 2rem;
    padding-left: 2rem;
  }
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
  const [postCode, setPostCode] = useState('');
  const [postCodeErrorMessage, setPostCodeErrorMessage] = useState('');
  const [isTokyoEnergyPartner, setIsTokyoEnergyPartner] = useState(true);
  const [isTodenETC, setIsTodenETC] = useState(true);
  const [contractCapacity, setContractCapacity] = useState('');
  const [currentUsage, setCurrentUsage] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log({
      postalCode: postCode,
      isTokyoEnergyPartner,
      isTodenETC,
      contractCapacity,
      currentUsage,
    });
  };

  const onPostCodeChange = (value: string) => {
    switch (value[0]) {
      case '1':
      case '5':
        setPostCodeErrorMessage('');
        setPostCode(value);
        break;
      default:
        setPostCodeErrorMessage('サービスエリア対象外です');
        setPostCode('');
        break;
    }
  };

  return (
    <Container>
      <Header
        title='電気代から\nかんたんシミュレーション'
        subTitle='検針票を用意しなくても OK\nいくらおトクになるのか今すぐわかります！'
      />
      <form onSubmit={handleSubmit}>
        <FormGroups label='郵便番号をご入力ください'>
          <PostCodeForm
            required
            label='電気を使用する場所の郵便番号'
            postCode={postCode}
            onPostCodeChange={onPostCodeChange}
            postCodeErrorMessage={postCodeErrorMessage}
            setPostCodeErrorMessage={setPostCodeErrorMessage}
          />
        </FormGroups>

        <FormGroups label='電気のご使用状況について教えてください'></FormGroups>

        <FormGroups label='現在の電気の使用状況について教えてください'></FormGroups>

        <Button type='submit'>結果を見る</Button>
      </form>
    </Container>
  );
};

export default Home;
