import { Header, Button } from '../components/General';
import { PostalCodeForm } from '../components/forms/PostalCodeForm';
import { PowerCompanyForm } from '../components/forms/PowerCompanyForm';
import { AmountForm } from '../components/forms/AmountForm';
import { useSimulationForm } from '../hooks/useSimulationForm';
import {
  getPowerCompanyOptions,
  getServicePlanOptions,
  getContractCapacityOptions,
} from '../utils/formOptions';
import { useMemo } from 'react';
import { MailForm } from '../components/forms/MailForm';

export const Simulation = () => {
  const {
    formData,
    errors,
    handleChange,
    handleSubmit,
    isFormValid,
    isSubmitting,
  } = useSimulationForm();

  // useMemoを使って、formDataの変更に応じて選択肢リストを再計算
  const companyOptions = useMemo(
    () => getPowerCompanyOptions(formData.area),
    [formData.area]
  );
  const planOptions = useMemo(
    () => getServicePlanOptions(formData.powerCompany),
    [formData.powerCompany]
  );
  const capacityOptions = useMemo(
    () =>
      getContractCapacityOptions(formData.powerCompany, formData.servicePlan),
    [formData.powerCompany, formData.servicePlan]
  );

  return (
    <div className="pb-20">
      <Header />
      <main>
        <PostalCodeForm
          value={formData.postalCode}
          error={errors.postalCode}
          onChange={(value) => handleChange('postalCode', value)}
        />
        <PowerCompanyForm
          powerCompanyValue={formData.powerCompany}
          servicePlanValue={formData.servicePlan}
          contractCapacityValue={formData.contractCapacity}
          companyOptions={companyOptions}
          planOptions={planOptions}
          capacityOptions={capacityOptions}
          powerCompanyError={errors.powerCompany}
          servicePlanError={errors.servicePlan}
          contractCapacityError={errors.contractCapacity}
          onFieldChange={handleChange}
          area={formData.area}
        />
        <AmountForm
          value={formData.lastMonthAmount}
          error={errors.lastMonthAmount}
          onChange={(value) => handleChange('lastMonthAmount', value)}
        />
        <MailForm
          value={formData.mailAddress}
          error={errors.mailAddress}
          onChange={(value) => handleChange('mailAddress', value)}
        />
        <div className="mt-8 px-4">
          <Button
            hasArrow
            isSubmitting={isSubmitting}
            disabled={!isFormValid || isSubmitting}
            onClick={handleSubmit}
          >
            結果を見る
          </Button>
        </div>
      </main>
    </div>
  );
};
