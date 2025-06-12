import { SectionHeading, FormField, SelectBox } from '../General';
import type { SelectOption } from '../General/SelectBox/SelectBox';
import {
  powerDataConfig,
  type CompanyKey,
} from '../../constants/powerDataConfig';

type Props = {
  powerCompanyValue: string;
  servicePlanValue: string;
  contractCapacityValue: string;
  // 表示するための選択肢リスト
  companyOptions: SelectOption[];
  planOptions: SelectOption[];
  capacityOptions: SelectOption[];
  powerCompanyError?: string;
  servicePlanError?: string;
  contractCapacityError?: string;
  onFieldChange: (
    field: 'powerCompany' | 'servicePlan' | 'contractCapacity',
    value: string
  ) => void;
  area: CompanyKey;
};

const PlanDescription = ({
  area,
  planValue,
}: {
  area: CompanyKey;
  planValue: string;
}) => {
  if (!planValue || area === 'other') {
    return null;
  }
  const plan =
    powerDataConfig[area]?.plans?.[
      planValue as keyof (typeof powerDataConfig)[typeof area]['plans']
    ];

  return (
    <div className="bg-main-gray px-3 py-0.5 rounded-b border-t border-dotted text-xs">
      <p>{plan.description}</p>
    </div>
  );
};

export const PowerCompanyForm = ({
  powerCompanyValue,
  servicePlanValue,
  contractCapacityValue,
  companyOptions,
  planOptions,
  capacityOptions,
  powerCompanyError,
  servicePlanError,
  contractCapacityError,
  onFieldChange,
  area,
}: Props) => {
  return (
    <div className="bg-white pt-4 pb-8 px-4 mt-8">
      <SectionHeading
        text="電気のご使用状況について教えてください"
        className="mt-4 -ml-4"
      />

      {/* 電力会社の表示 (companyOptionsが空なら非表示) */}
      {companyOptions.length > 0 && (
        <FormField
          required
          label="電力会社"
          name="powerCompany"
          error={powerCompanyError}
          className="mt-4"
        >
          <SelectBox
            value={powerCompanyValue}
            options={companyOptions}
            onChange={(value) => onFieldChange('powerCompany', value)}
            error={powerCompanyError}
          />
        </FormField>
      )}

      <FormField
        required
        label="プラン"
        name="servicePlan"
        error={servicePlanError}
        className="mt-4"
      >
        <SelectBox
          value={servicePlanValue}
          options={planOptions}
          onChange={(value) => onFieldChange('servicePlan', value)}
          error={servicePlanError}
          placeholder="プランを選択してください"
          disabled={planOptions.length === 0}
        />
        <PlanDescription area={area} planValue={servicePlanValue} />
      </FormField>

      {/* 契約容量の表示 (capacityOptionsが空なら非表示) */}
      {capacityOptions.length > 0 && (
        <FormField
          required
          label="契約容量"
          name="contractCapacity"
          error={contractCapacityError}
          className="mt-4"
        >
          <SelectBox
            value={contractCapacityValue}
            options={capacityOptions}
            onChange={(value) => onFieldChange('contractCapacity', value)}
            error={contractCapacityError}
            disabled={capacityOptions.length === 0}
          />
        </FormField>
      )}
    </div>
  );
};
