"use client";

import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { simulationFormSchema, type SimulationFormValues } from "@/lib/schema";
import { VALID_AMPERES } from "@/lib/constants";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

type Props = {
  onSubmit: (values: SimulationFormValues) => void;
  isLoading: boolean;
};

export function SimulationForm({ onSubmit, isLoading }: Props) {
  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors },
  } = useForm<SimulationFormValues>({
    resolver: zodResolver(simulationFormSchema),
    defaultValues: {
      ampere: 30,
      kwh: undefined,
    },
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-4">
      <div className="space-y-1">
        <Label htmlFor="ampere">契約アンペア</Label>
        <Select
          defaultValue="30"
          onValueChange={(val) => setValue("ampere", Number(val) as SimulationFormValues["ampere"])}
        >
          <SelectTrigger id="ampere" className="w-full">
            <SelectValue placeholder="アンペアを選択" />
          </SelectTrigger>
          <SelectContent>
            {VALID_AMPERES.map((a) => (
              <SelectItem key={a} value={String(a)}>
                {a}A
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        {errors.ampere && (
          <p className="text-sm text-destructive">{errors.ampere.message}</p>
        )}
      </div>

      <div className="space-y-1">
        <Label htmlFor="kwh">使用量 (kWh)</Label>
        <Input
          id="kwh"
          type="number"
          min={0}
          max={9999}
          placeholder="例: 300"
          {...register("kwh", {
            setValueAs: (v: string) => (v === "" ? undefined : Number(v)),
          })}
        />
        {errors.kwh?.message && (
          <p className="text-sm text-destructive">{errors.kwh.message}</p>
        )}
      </div>

      <Button type="submit" disabled={isLoading} className="w-full">
        {isLoading ? "計算中..." : "料金を比較する"}
      </Button>
    </form>
  );
}
