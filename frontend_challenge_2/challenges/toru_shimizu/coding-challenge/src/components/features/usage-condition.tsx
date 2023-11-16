import { useAtomValue } from "jotai";
import { useEffect } from "react";
import { useFormContext } from "react-hook-form";
import { Select } from "../ui/select";
import styles from "./usage-condition.module.scss";
import { companiesAtom } from "@/src/states/options";
import { getCapacities } from "@/src/utils/get-capacities";
import { getPlans } from "@/src/utils/get-plans";

export const UsageCondition = () => {
  const {
    register,
    formState: { errors },
    watch,
    setValue,
  } = useFormContext();

  const company = watch("company");
  const companies = useAtomValue(companiesAtom);
  const plans = getPlans(company);
  const plan = watch("plan");

  const capacities = getCapacities({
    company,
    plan,
  });

  const enabledCapacity = !(plan === "従量電灯A" && company === "関西電力");

  useEffect(() => {
    if (!enabledCapacity) {
      setValue("capacity", "");
    }
  }, [enabledCapacity, setValue]);

  return (
    <div className={styles.usageCondition}>
      <Select
        attention="郵便番号入力後に選択できます"
        error={errors.company?.message?.toString()}
        label="電力会社"
        options={companies}
        {...register("company")}
      />
      <Select
        label="プラン"
        options={plans}
        attention="電力会社選択後に選択できます"
        error={errors.plan?.message?.toString()}
        {...register("plan")}
      />
      {enabledCapacity ? (
        <Select
          options={capacities}
          label="容量"
          attention="プラン選択後に選択できます"
          error={errors.capacity?.message?.toString()}
          {...register("capacity")}
        />
      ) : (
        <>
          <p className={styles.label}>容量</p>
          <p className={styles.text}>容量の選択は不要です</p>
        </>
      )}
    </div>
  );
};
