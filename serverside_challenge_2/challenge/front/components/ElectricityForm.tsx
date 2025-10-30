import { useState } from "react";

interface ElectricityFormProps {
  onCalculate: (ampere: number, usage: number) => void;
  loading: boolean;
}

export function ElectricityForm({ onCalculate, loading }: ElectricityFormProps) {
  const TARGET_AMPERES = [10, 15, 20, 30, 40, 50, 60];
  const [ampere, setAmpere] = useState(TARGET_AMPERES[0]);
  const [usage, setUsage] = useState(200);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onCalculate(ampere, usage);
  };

  return (
    <form onSubmit={handleSubmit} className="mb-8 space-y-5">
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">
          契約アンペア数 (A)
        </label>
        <select
          value={ampere}
          onChange={(e) => setAmpere(Number(e.target.value))}
          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-gray-800 bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none"
        >
          {TARGET_AMPERES.map((a) => (
            <option key={a} value={a}>
              {a}A
            </option>
          ))}
        </select>
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1">
          使用量 (kWh)
        </label>
        <input
          type="number"
          value={usage}
          onChange={(e) => setUsage(Number(e.target.value))}
          className="w-full border border-gray-300 rounded-lg px-3 py-2 text-gray-800 placeholder-gray-500 bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none"
          min={0}
          placeholder="例: 200"
        />
      </div>

      <button
        type="submit"
        disabled={loading}
        className={`w-full py-2.5 rounded-lg text-white font-semibold transition ${
          loading
            ? "bg-gray-400 cursor-not-allowed"
            : "bg-blue-600 hover:bg-blue-700"
        }`}
      >
        {loading ? "計算中..." : "計算する"}
      </button>
    </form>
  );
}
