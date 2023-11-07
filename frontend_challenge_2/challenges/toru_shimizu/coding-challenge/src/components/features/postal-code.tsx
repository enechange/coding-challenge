import { useFormContext } from "react-hook-form";
import { Input } from "../ui/input";

export const PostalCode = () => {
  const {
    register,
    formState: { errors },
  } = useFormContext();

  return (
    <Input
      type="numeric"
      label="電気を使用する場所の郵便番号"
      maxLength={7}
      attention="例) 1040031"
      error={errors.postalCode?.message?.toString()}
      {...register("postalCode")}
    />
  );
};
