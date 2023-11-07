import { Select } from "../ui/select";

type Props = {};

const DUMMY_OPTIONS = ["A", "B", "C"];

export const Plan = () => {
  return (
    <Select
      name={"plan"}
      label="プラン"
      options={DUMMY_OPTIONS}
      attention="※電力会社選択後に選択できます"
    />
  );
};
