import styled from '@emotion/styled';

import Header from '@/components/header';
import FormGroups from '@/components/form-groups';
import PostCodeForm from '@/components/form-containers/post-code';
import SelectionForm from '@/components/form-containers/selection';
import FormWithUnit from '@/components/form-containers/form-with-unit';
import MailForm from '@/components/form-containers/mail-address';
import SubmitButton from '@/components/submit-button';

export type SimulationFormProps = {
  postCode: string;
  onPostCodeChange: (postCode: string) => void;
  postCodeErrorMessage: string;
  setPostCodeErrorMessage: (postCodeErrorMessage: string) => void;
  electricCompanySelections: string[];
  selectedElectricCompany: string;
  onElectricCompanyChange: (electricCompany: string) => void;
  electricCompanyErrorMessage: string;
  setElectricCompanyErrorMessage: (electricCompanyErrorMessage: string) => void;
  planSelections: string[];
  selectedPlan: string;
  onPlanChange: (plan: string) => void;
  planErrorMessage: string;
  setPlanErrorMessage: (planErrorMessage: string) => void;
  contractCapacitySelections: string[];
  selectedContractCapacity: string;
  onContractCapacitySelectionChange: (contractCapacity: string) => void;
  contractCapacityErrorMessage: string;
  setContractCapacityErrorMessage: (
    contractCapacityErrorMessage: string,
  ) => void;
  contractCapacity: number | undefined;
  onContractCapacityValueChange: (contractCapacity: number | undefined) => void;
  electricBill: number | undefined;
  onElectricBillChange: (electricBill: number | undefined) => void;
  electricBillErrorMessage: string;
  setElectricBillErrorMessage: (electricBillErrorMessage: string) => void;
  mailAddress: string;
  onMailAddressChange: (mailAddress: string) => void;
  mailAddressErrorMessage: string;
  setMailAddressErrorMessage: (mailAddressErrorMessage: string) => void;
  postCodeCompleted: boolean;
  electricCompanyCompleted: boolean;
  planCompleted: boolean;
  contractCapacityCompleted: boolean;
  electricBillCompleted: boolean;
  mailAddressCompleted: boolean;
  handleSubmit: (event: React.FormEvent<HTMLFormElement>) => void;
};

const SimulationForm = ({
  postCode,
  onPostCodeChange,
  postCodeErrorMessage,
  setPostCodeErrorMessage,
  electricCompanySelections,
  selectedElectricCompany,
  onElectricCompanyChange,
  electricCompanyErrorMessage,
  setElectricCompanyErrorMessage,
  planSelections,
  selectedPlan,
  onPlanChange,
  planErrorMessage,
  setPlanErrorMessage,
  contractCapacitySelections,
  selectedContractCapacity,
  onContractCapacitySelectionChange,
  contractCapacityErrorMessage,
  setContractCapacityErrorMessage,
  contractCapacity,
  onContractCapacityValueChange,
  electricBill,
  onElectricBillChange,
  electricBillErrorMessage,
  setElectricBillErrorMessage,
  mailAddress,
  onMailAddressChange,
  mailAddressErrorMessage,
  setMailAddressErrorMessage,
  postCodeCompleted,
  electricCompanyCompleted,
  planCompleted,
  contractCapacityCompleted,
  electricBillCompleted,
  mailAddressCompleted,
  handleSubmit,
}: SimulationFormProps) => {
  return (
    <div>
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
            onSelectionChange={onContractCapacitySelectionChange}
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
            onValueChange={onContractCapacityValueChange}
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
    </div>
  );
};

export default SimulationForm;
