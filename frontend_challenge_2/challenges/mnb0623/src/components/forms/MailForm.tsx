import { TextInput, SectionHeading, FormField } from '../General';

type Props = {
  value: string;
  error?: string;
  onChange: (value: string) => void;
};

export const MailForm = ({ value, error, onChange }: Props) => {
  return (
    <div className="bg-white pt-4 pb-8 px-4 mt-8">
      <SectionHeading
        className="-ml-4"
        text="送信先のメールアドレスを教えてください"
      />
      <FormField
        required
        label="メールアドレス"
        name="mailAddress"
        error={error}
      >
        <TextInput
          value={value}
          onChange={onChange}
          error={error}
          type="text"
          placeholder="enechange@example.com"
        />
      </FormField>
    </div>
  );
};
