import { Input } from "../ui/input";

export const PostalCode = () => {
  return (
    <div className="postal-code">
      <Input
        type="numeric"
        label="電気を使用する場所の郵便番号"
        maxLength={7}
        attention="例) 1040031"
      />
    </div>
  );
};
