import { useFormContext } from "react-hook-form";
import { Select } from "../ui/select";
import { getCapacities } from "@/src/utils/get-capacities";

type Props = {
  company: string;
  plan: string;
};

export const Capacity = ({ company, plan }: Props) => {
  const {
    register,
    formState: { errors },
  } = useFormContext();

  const capacities = getCapacities({
    company,
    plan,
  });

  return (
    <Select
      options={capacities}
      label="容量"
      attention="※プラン選択後に選択できます"
      error={errors.plan?.message?.toString()}
      {...register("capacity")}
    />
  );
};
