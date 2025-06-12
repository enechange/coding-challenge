import { PostalCodeInput, SectionHeading, FormField } from '../General';

type Props = {
  value: string;
  error?: string;
  onChange: (value: string) => void;
};

export const PostalCodeForm = ({ value, error, onChange }: Props) => {
  return (
    <div className="bg-white pt-4 pb-8 px-4">
      <SectionHeading className="-ml-4" text="郵便番号をご入力ください" />
      <FormField
        required
        label="電気を使用する場所の郵便番号"
        name="postalCode"
        error={error}
      >
        <PostalCodeInput value={value} error={error} onChange={onChange} />
      </FormField>
    </div>
  );
};
