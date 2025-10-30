import { ElectricityPlanResult } from "@/types/electricity";

export function ResultCard({ result }: { result: ElectricityPlanResult }) {
  return (
    <div className="bg-gray-50 p-5 rounded-xl shadow-sm hover:shadow-md border border-gray-100 transition-transform hover:-translate-y-0.5">
      <p className="text-gray-900 font-semibold text-lg leading-snug break-words">
        {result.provider_name}
      </p>
      <p className="text-gray-600 text-sm mb-2 leading-tight break-words">
        {result.plan_name}
      </p>
      <p className="text-2xl font-bold text-blue-600 mt-2 text-right">
        {result.price.toLocaleString()}円
      </p>
    </div>
  );
}
