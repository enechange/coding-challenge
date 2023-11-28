'use client';

import { useState } from 'react';

import SimulationForm from '../components/simulation-form';

const TOKYO_ELECTRIC_POWER = '東京電力';
const KANSAI_ELECTRIC_POWER = '関西電力';
const TOKYO_AREA = '1';
const KANSAI_AREA = '5';

const AREA_TO_ELECTRIC_COMPANY = {
  [TOKYO_AREA]: TOKYO_ELECTRIC_POWER,
  [KANSAI_AREA]: KANSAI_ELECTRIC_POWER,
} as const;

const PLAN_A = '従量電灯 A';
const PLAN_B = '従量電灯 B';
const PLAN_C = '従量電灯 C';

const TOKYO_ELECTRIC_POWER_PLANS = [PLAN_B, PLAN_C] as const;
const KANSAI_ELECTRIC_POWER_PLANS = [PLAN_A, PLAN_B] as const;

const TOKYO_ELECTRIC_POWER_B_CONTRACT_CAPACITY = [
  '10A',
  '15A',
  '20A',
  '30A',
  '40A',
  '50A',
  '60A',
] as const;

const SimulationFormContainer = () => {
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
    setElectricCompanyCompleted(false);
    setPlanCompleted(false);
    setContractCapacityCompleted(false);
    setElectricBillCompleted(false);
    setMailAddressCompleted(false);
    if (value.length === 0) {
      setPostCodeCompleted(false);
      return;
    }
    const electricCompany =
      AREA_TO_ELECTRIC_COMPANY[
        value[0] as keyof typeof AREA_TO_ELECTRIC_COMPANY
      ];
    setSelectedElectricCompany('');
    if (electricCompany) {
      setArea(value[0]);
      setPostCode(value);
      setPostCodeErrorMessage('');
      setElectricCompanySelections([electricCompany, 'その他']);
      setPostCodeCompleted(true);
    } else {
      setArea('');
      setElectricCompanySelections([]);
      setPostCodeErrorMessage('サービスエリア対象外です');
      setPostCode('');
    }
  };

  const onElectricCompanyChange = (value: string) => {
    setPlanCompleted(false);
    setContractCapacityCompleted(false);
    setElectricBillCompleted(false);
    setMailAddressCompleted(false);
    if (value.length === 0) {
      return;
    }
    setSelectedElectricCompany(value);
    setSelectedPlan('');
    if (area === TOKYO_AREA && value === TOKYO_ELECTRIC_POWER) {
      setElectricCompanyErrorMessage('');
      setPlanSelections(TOKYO_ELECTRIC_POWER_PLANS);
      setElectricCompanyCompleted(true);
    } else if (area === KANSAI_AREA && value === KANSAI_ELECTRIC_POWER) {
      setElectricCompanyErrorMessage('');
      setPlanSelections(KANSAI_ELECTRIC_POWER_PLANS);
      setElectricCompanyCompleted(true);
    } else if (value === 'その他') {
      setElectricCompanyErrorMessage('シミュレーション対象外です');
      setPlanSelections([]);
      setElectricCompanyCompleted(false);
    }
  };

  const onPlanChange = (value: string) => {
    setContractCapacityCompleted(false);
    setElectricBillCompleted(false);
    setMailAddressCompleted(false);
    if (value.length === 0) {
      setPlanCompleted(false);
      return;
    }
    setSelectedPlan(value);
    setPlanCompleted(true);
    setSelectedContractCapacity('');

    if (value === PLAN_B && selectedElectricCompany === TOKYO_ELECTRIC_POWER) {
      setContractCapacitySelections(TOKYO_ELECTRIC_POWER_B_CONTRACT_CAPACITY);
    } else if (
      value === PLAN_C &&
      selectedElectricCompany === TOKYO_ELECTRIC_POWER
    ) {
      setContractCapacitySelections([]);
    } else if (
      value === PLAN_B &&
      selectedElectricCompany === KANSAI_ELECTRIC_POWER
    ) {
      setContractCapacitySelections([]);
    } else if (
      value === PLAN_A &&
      selectedElectricCompany === KANSAI_ELECTRIC_POWER
    ) {
      setPlanCompleted(false);
      setContractCapacityCompleted(true);
      setContractCapacitySelections([]);
    } else {
      setContractCapacitySelections([]);
    }
  };

  const onContractCapacitySelectionChange = (value: string) => {
    setElectricBillCompleted(false);
    setMailAddressCompleted(false);
    setSelectedContractCapacity(value);
    if (value.length > 0) {
      setContractCapacityCompleted(true);
    } else {
      setContractCapacityCompleted(false);
    }
  };

  const onContractCapacityValueChange = (value: number | undefined) => {
    setElectricBillCompleted(false);
    setMailAddressCompleted(false);
    setContractCapacity(value);
    if (value === undefined) {
      setContractCapacityCompleted(false);
    } else {
      setContractCapacityCompleted(true);
    }
  };

  const onElectricBillChange = (value: number | undefined) => {
    setMailAddressCompleted(false);
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
    <SimulationForm
      postCode={postCode}
      postCodeErrorMessage={postCodeErrorMessage}
      electricCompanySelections={electricCompanySelections}
      selectedElectricCompany={selectedElectricCompany}
      electricCompanyErrorMessage={electricCompanyErrorMessage}
      planSelections={planSelections}
      selectedPlan={selectedPlan}
      planErrorMessage={planErrorMessage}
      contractCapacitySelections={contractCapacitySelections}
      selectedContractCapacity={selectedContractCapacity}
      contractCapacityErrorMessage={contractCapacityErrorMessage}
      contractCapacity={contractCapacity}
      electricBill={electricBill}
      electricBillErrorMessage={electricBillErrorMessage}
      mailAddress={mailAddress}
      mailAddressErrorMessage={mailAddressErrorMessage}
      postCodeCompleted={postCodeCompleted}
      electricCompanyCompleted={electricCompanyCompleted}
      planCompleted={planCompleted}
      contractCapacityCompleted={contractCapacityCompleted}
      electricBillCompleted={electricBillCompleted}
      mailAddressCompleted={mailAddressCompleted}
      handleSubmit={handleSubmit}
      onPostCodeChange={onPostCodeChange}
      onElectricCompanyChange={onElectricCompanyChange}
      onPlanChange={onPlanChange}
      onContractCapacitySelectionChange={onContractCapacitySelectionChange}
      onContractCapacityValueChange={onContractCapacityValueChange}
      onElectricBillChange={onElectricBillChange}
      onMailAddressChange={onMailAddressChange}
      setPostCodeErrorMessage={setPostCodeErrorMessage}
      setElectricCompanyErrorMessage={setElectricCompanyErrorMessage}
      setPlanErrorMessage={setPlanErrorMessage}
      setContractCapacityErrorMessage={setContractCapacityErrorMessage}
      setElectricBillErrorMessage={setElectricBillErrorMessage}
      setMailAddressErrorMessage={setMailAddressErrorMessage}
    />
  );
};

export default SimulationFormContainer;
