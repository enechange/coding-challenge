import { useFormContext } from "react-hook-form";
import { Select } from "../ui/select";

type Props = {};

const DUMMY_CAPACITIES = ["10", "20", "30"];

export const Capacity = () => {
  const {
    register,
    formState: { errors },
  } = useFormContext();

  return (
    <Select
      options={DUMMY_CAPACITIES}
      label="容量"
      attention="※プラン選択後に選択できます"
      error={errors.plan?.message?.toString()}
      {...register("capacity")}
    />
  );
};
