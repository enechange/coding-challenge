import { useSetAtom } from "jotai";
import { useCallback } from "react";
import { useFormContext } from "react-hook-form";
import { Input } from "../ui/input";
import { companiesAtom } from "@/src/states/options";
import { getCompanies } from "@/src/utils/get-companies";

export const PostalCode = () => {
  const setCompanies = useSetAtom(companiesAtom);

  const {
    register,
    formState: { errors },
  } = useFormContext();

  const onBlur = useCallback(
    (event: React.FocusEvent<HTMLInputElement>) => {
      const companies = getCompanies(event.target.value);
      setCompanies(companies);
    },
    [setCompanies],
  );

  return (
    <Input
      type="number"
      label="電気を使用する場所の郵便番号"
      maxLength={7}
      inputmode="numeric"
      placeholder="1040031"
      error={errors.postalCode?.message?.toString()}
      {...register("postalCode")}
      onBlur={onBlur}
    />
  );
};
