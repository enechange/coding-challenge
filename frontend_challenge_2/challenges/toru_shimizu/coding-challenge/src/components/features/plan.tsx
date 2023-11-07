import { useFormContext } from "react-hook-form";
import { Select } from "../ui/select";
import { getPlans } from "@/src/utils/get-plans";

type Props = {
  companyName: string;
};

export const Plan = ({ companyName }: Props) => {
  const {
    register,
    formState: { errors },
    getValues,
  } = useFormContext();

  const company = getValues(companyName);
  const plans = getPlans(company);

  return (
    <Select
      label="プラン"
      options={plans}
      attention="※電力会社選択後に選択できます"
      error={errors.plan?.message?.toString()}
      {...register("plan")}
    />
  );
};
