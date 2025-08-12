import React from "react";

interface SectionProps extends React.HTMLAttributes<HTMLDivElement> {
  title: string;
}

export const Section = ({ title, children }: SectionProps) => {
  return (
    <div className="pt-5 pb-6 bg-white">
      <div className="text-base border-l-4 border-orange-300 px-3 py-2 mb-4 font-bold">
        {title}
      </div>
      {children}
    </div>
  );
};

Section.displayName = "Section";
