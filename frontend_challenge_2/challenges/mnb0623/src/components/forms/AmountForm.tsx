import { TextInput, SectionHeading, FormField } from '../General';

type Props = {
  value: string;
  error?: string;
  onChange: (value: string) => void;
};

export const AmountForm = ({ value, error, onChange }: Props) => {
  return (
    <div className="bg-white pt-4 pb-8 px-4 mt-8">
      <SectionHeading
        className="-ml-4"
        text=" 現在の電気の使用状況について教えてください"
      />
      <FormField
        required
        label="先月の電気代は？"
        name="postalCode"
        error={error}
        endAdornment="円"
      >
        <TextInput
          value={value}
          onChange={onChange}
          error={error}
          type="text"
          placeholder="12345"
        />
      </FormField>
    </div>
  );
};
