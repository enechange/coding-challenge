import { Select } from "../ui/select";

type Props = {};

const DUMMY_CAPACITIES = ["10", "20", "30"];

export const Capacity = () => {
  return (
    <Select
      name="capacity"
      options={DUMMY_CAPACITIES}
      label="容量"
      attention="※プラン選択後に選択できます"
    />
  );
};
