import React from "react";
import { cn } from "@/lib/utils";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary";
  size?: "md";
  loading?: boolean;
  iconPrefix?: React.ReactNode;
  iconSuffix?: React.ReactNode;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  (
    {
      className,
      type = "button",
      variant = "primary",
      size = "md",
      loading = false,
      iconPrefix,
      iconSuffix,
      children,
      disabled,
      ...props
    },
    ref
  ) => {
    return (
      <button
        className={cn(
          "inline-flex gap-4 items-center justify-center rounded-sm font-medium transition-colors focus:outline-none focus:ring-2 disabled:pointer-events-none disabled:opacity-50 duration-300 cursor-pointer",
          {
            "bg-blue-800 text-white hover:bg-blue-900 focus:ring-blue-500":
              variant === "primary",
            "h-12 px-6 text-base": size === "md",
          },
          className
        )}
        type={type}
        disabled={disabled || loading}
        ref={ref}
        {...props}
      >
        {iconPrefix}
        {children}
        {iconSuffix}
      </button>
    );
  }
);

Button.displayName = "Button";
