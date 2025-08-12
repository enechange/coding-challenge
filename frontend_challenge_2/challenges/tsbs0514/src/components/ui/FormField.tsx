import React from "react";
import { TbAlertTriangleFilled } from "react-icons/tb";

interface FormFieldProps {
  label: string;
  labelHtmlFor?: string;
  error?: string;
  required?: boolean;
  children: React.ReactNode;
  description?: string;
}

export function FormField({
  label,
  labelHtmlFor,
  error,
  required = false,
  children,
  description,
}: FormFieldProps) {
  return (
    <div className="flex flex-col gap-3 px-4">
      <label
        htmlFor={labelHtmlFor}
        className="flex items-center gap-2 text-sm font-bold text-gray-700"
      >
        {required && (
          <span className="grid place-items-center bg-red-400 font-bold text-white pl-2 pr-1 py-0.5 text-[10px] tracking-[0.4em]">
            必須
          </span>
        )}
        {label}
      </label>
      <div>
        {children}
        {description && (
          <p className="text-xs bg-gray-200 pt-3 pb-2 px-2 -mt-1 rounded-b-sm">
            {description}
          </p>
        )}
      </div>
      {error && (
        <p
          className="p-2.5 flex text-xs items-center gap-2 bg-red-400 text-white rounded-sm font-bold"
          role="alert"
        >
          <TbAlertTriangleFilled className="w-5 h-5" />
          {error}
        </p>
      )}
    </div>
  );
}
