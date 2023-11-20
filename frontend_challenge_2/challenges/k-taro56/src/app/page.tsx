'use client';

import { useState } from 'react';
import styled from '@emotion/styled';

import Header from '@/components/header';
import FormGroups from '@/components/form-groups';
import PostCodeForm from '@/components/form-containers/post-code';
import SelectionForm from '@/components/form-containers/selection';
import FormWithUnit from '@/components/form-containers/form-with-unit';
import MailForm from '@/components/form-containers/mail-address';
import SubmitButton from '@/components/submit-button';

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
    padding-bottom: 1.5rem;
    padding-right: 1.5rem;
    padding-left: 1.5rem;
  }
  @media (min-width: 1024px) {
    padding-top: 0;
    padding-bottom: 2rem;
    padding-right: 2rem;
    padding-left: 2rem;
  }
`;

const TOKYO_ELECTRIC_POWER = '東京電力';
const KANSAI_ELECTRIC_POWER = '関西電力';
const TOKYO_AREA = '1';
const KANSAI_AREA = '5';

const AREA_TO_ELECTRIC_COMPANY = {
  [TOKYO_AREA]: TOKYO_ELECTRIC_POWER,
  [KANSAI_AREA]: KANSAI_ELECTRIC_POWER,
};

const TOKYO_ELECTRIC_POWER_PLANS = ['従量電灯 B', '従量電灯 C'];
const KANSAI_ELECTRIC_POWER_PLANS = ['従量電灯 A', '従量電灯 B'];

const TOKYO_ELECTRIC_POWER_B_CONTRACT_CAPACITY = [
  '10A',
  '15A',
  '20A',
  '30A',
  '40A',
  '50A',
  '60A',
];

const Home = () => {
  const [area, setArea] = useState('');
  const [postCode, setPostCode] = useState('');
  const [postCodeErrorMessage, setPostCodeErrorMessage] = useState('');
  const [electricCompanySelections, setElectricCompanySelections] = useState<
    string[]
  >([]);
  const [selectedElectricCompany, setSelectedElectricCompany] = useState('');
  const [electricCompanyErrorMessage, setElectricCompanyErrorMessage] =
    useState('');
  const [planSelections, setPlanSelections] = useState<string[]>([]);
  const [selectedPlan, setSelectedPlan] = useState('');
  const [planErrorMessage, setPlanErrorMessage] = useState('');
  const [contractCapacitySelections, setContractCapacitySelections] = useState<
    string[]
  >([]);
  const [selectedContractCapacity, setSelectedContractCapacity] = useState('');
  const [contractCapacityErrorMessage, setContractCapacityErrorMessage] =
    useState('');
  const [contractCapacity, setContractCapacity] = useState<number>();
  const [electricBill, setElectricBill] = useState<number>();
  const [electricBillErrorMessage, setElectricBillErrorMessage] = useState('');
  const [mailAddress, setMailAddress] = useState('');
  const [mailAddressErrorMessage, setMailAddressErrorMessage] = useState('');

  const [postCodeCompleted, setPostCodeCompleted] = useState(false);
  const [electricCompanyCompleted, setElectricCompanyCompleted] =
    useState(false);
  const [planCompleted, setPlanCompleted] = useState(false);
  const [contractCapacityCompleted, setContractCapacityCompleted] =
    useState(false);
  const [electricBillCompleted, setElectricBillCompleted] = useState(false);
  const [mailAddressCompleted, setMailAddressCompleted] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
  };

  const onPostCodeChange = (value: string) => {
    if (value.length === 0) {
      setPostCodeCompleted(false);
      return;
    }
    const electricCompany =
      AREA_TO_ELECTRIC_COMPANY[
        value[0] as keyof typeof AREA_TO_ELECTRIC_COMPANY
      ];
    if (electricCompany) {
      setArea(value[0]);
      setPostCode(value);
      setPostCodeErrorMessage('');
      setElectricCompanySelections([electricCompany, 'その他']);
      setPostCodeCompleted(true);
    } else {
      setElectricCompanySelections([]);
      setPostCodeErrorMessage('サービスエリア対象外です');
      setPostCode('');
      setArea('');
      setPostCodeCompleted(false);
    }
  };

  const onElectricCompanyChange = (value: string) => {
    if (value.length === 0) {
      setElectricCompanyCompleted(false);
      return;
    }
    setSelectedElectricCompany(value);
    if (area === TOKYO_AREA && value === TOKYO_ELECTRIC_POWER) {
      setElectricCompanyErrorMessage('');
      setPlanSelections(TOKYO_ELECTRIC_POWER_PLANS);
      setElectricCompanyCompleted(true);
      return;
    } else if (area === KANSAI_AREA && value === KANSAI_ELECTRIC_POWER) {
      setElectricCompanyErrorMessage('');
      setPlanSelections(KANSAI_ELECTRIC_POWER_PLANS);
      setElectricCompanyCompleted(true);
      return;
    } else if (value === 'その他') {
      setElectricCompanyErrorMessage('シミュレーション対象外です');
    }
    setPlanSelections([]);
    setElectricCompanyCompleted(false);
  };

  const onPlanChange = (value: string) => {
    if (value.length === 0) {
      setPlanCompleted(false);
      return;
    }
    setSelectedPlan(value);
    setPlanCompleted(true);

    if (
      value === '従量電灯 B' &&
      selectedElectricCompany === TOKYO_ELECTRIC_POWER
    ) {
      setContractCapacitySelections(TOKYO_ELECTRIC_POWER_B_CONTRACT_CAPACITY);
    } else if (
      value === '従量電灯 C' &&
      selectedElectricCompany === TOKYO_ELECTRIC_POWER
    ) {
      setContractCapacitySelections([]);
    } else if (
      value === '従量電灯 B' &&
      selectedElectricCompany === KANSAI_ELECTRIC_POWER
    ) {
      setContractCapacitySelections([]);
    } else {
      setContractCapacitySelections([]);
    }
  };

  const onSelectionChange = (value: string) => {
    setSelectedContractCapacity(value);
    if (value.length > 0) {
      setContractCapacityCompleted(true);
    } else {
      setContractCapacityCompleted(false);
    }
  };

  const onInputValueChange = (value: number | undefined) => {
    setContractCapacity(value);
    if (value === undefined) {
      setContractCapacityCompleted(false);
    } else {
      setContractCapacityCompleted(true);
    }
  };

  const onElectricBillChange = (value: number | undefined) => {
    setElectricBill(value);
    if (value === undefined) {
      setElectricBillCompleted(false);
    } else {
      setElectricBillCompleted(true);
    }
  };

  const onMailAddressChange = (value: string) => {
    if (value.length === 0) {
      setMailAddressCompleted(false);
      return;
    }
    setMailAddress(value);
    setMailAddressCompleted(true);
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

        <FormGroups
          label='電気のご使用状況について教えてください'
          isVisible={postCodeCompleted}
        >
          <SelectionForm
            label='電力会社'
            required
            selections={electricCompanySelections}
            selected={selectedElectricCompany}
            onSelectionChange={onElectricCompanyChange}
            errorMessage={electricCompanyErrorMessage}
            setErrorMessage={setElectricCompanyErrorMessage}
          />
          <SelectionForm
            label='プラン'
            required
            isVisible={electricCompanyCompleted}
            selections={planSelections}
            selected={selectedPlan}
            onSelectionChange={onPlanChange}
            errorMessage={planErrorMessage}
            setErrorMessage={setPlanErrorMessage}
          />
          <SelectionForm
            label='契約容量'
            required
            isVisible={planCompleted && contractCapacitySelections.length !== 0}
            selections={contractCapacitySelections}
            selected={selectedContractCapacity}
            onSelectionChange={onSelectionChange}
            errorMessage={contractCapacityErrorMessage}
            setErrorMessage={setContractCapacityErrorMessage}
          />
          <FormWithUnit
            label='契約容量'
            required
            isVisible={planCompleted && contractCapacitySelections.length === 0}
            placeholder='24'
            value={contractCapacity}
            unit='kVA'
            min={6}
            max={49}
            onValueChange={onInputValueChange}
            errorMessage={contractCapacityErrorMessage}
            setErrorMessage={setContractCapacityErrorMessage}
          />
        </FormGroups>

        <FormGroups
          label='現在の電気の使用状況について教えてください'
          isVisible={contractCapacityCompleted}
        >
          <FormWithUnit
            required
            label='先月の電気代は？'
            placeholder='5000'
            value={electricBill}
            unit='円'
            min={1000}
            onValueChange={onElectricBillChange}
            errorMessage={electricBillErrorMessage}
            setErrorMessage={setElectricBillErrorMessage}
          />
        </FormGroups>

        <FormGroups
          label='メールアドレスをご入力ください'
          isVisible={electricBillCompleted}
        >
          <MailForm
            required
            label='メールアドレス'
            mailAddress={mailAddress}
            onMailAddressChange={onMailAddressChange}
            mailAddressErrorMessage={mailAddressErrorMessage}
            setMailAddressErrorMessage={setMailAddressErrorMessage}
          />
        </FormGroups>

        {mailAddressCompleted && <SubmitButton content='結果を見る' />}
      </form>
    </Container>
  );
};

export default Home;
