import { useFormContext } from "react-hook-form";
import { Select } from "../ui/select";

type Props = {};

const DUMMY_OPTIONS = ["A", "B", "C"];

export const Plan = () => {
  const {
    register,
    formState: { errors },
  } = useFormContext();

  return (
    <Select
      label="プラン"
      options={DUMMY_OPTIONS}
      attention="※電力会社選択後に選択できます"
      error={errors.plan?.message?.toString()}
      {...register("plan")}
    />
  );
};
