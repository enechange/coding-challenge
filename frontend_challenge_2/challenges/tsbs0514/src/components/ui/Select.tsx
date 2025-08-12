import React from "react";
import { cn } from "@/lib/utils";
import type { ElectricPlan } from "@/types";
import { FaChevronDown } from "react-icons/fa";

export type SelectValue = string | ElectricPlan;
export interface SelectOption<V extends SelectValue = string> {
  value: V;
  label: string;
}

interface SelectProps<V extends SelectValue = string>
  extends Omit<React.SelectHTMLAttributes<HTMLSelectElement>, "children"> {
  options: ReadonlyArray<SelectOption<V>>;
  placeholder?: string;
  error?: boolean;
}

export const Select = React.forwardRef<HTMLSelectElement, SelectProps>(
  ({ className, options, placeholder, error, ...props }, ref) => {
    return (
      <div className="bg-gray-200 p-1 rounded-sm relative">
        <select
          className={cn(
            "flex h-12 w-full bg-white px-4 py-2 text-base focus:border-orange-500 focus:outline-none focus:ring-2 focus:ring-orange-500/20 disabled:cursor-not-allowed disabled:opacity-50 [:has(option:checked[value=''])]:text-gray-400 appearance-none cursor-pointer",
            error &&
              "border-red-500 focus:border-red-500 focus:ring-red-500/20",
            className
          )}
          ref={ref}
          {...props}
        >
          {placeholder && (
            <option value="" hidden>
              {placeholder}
            </option>
          )}
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
        <FaChevronDown className="w-6 h-6 absolute right-4 top-1/2 -translate-y-1/2 text-orange-400 pointer-events-none" />
      </div>
    );
  }
);

Select.displayName = "Select";
