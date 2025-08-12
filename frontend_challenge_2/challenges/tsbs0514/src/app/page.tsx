"use client";

import { useState, useEffect } from "react";
import { ElectricSimulationForm } from "@/components/ElectricSimulationForm";

export default function Home() {
  const [isInitialized, setIsInitialized] = useState(false);

  useEffect(() => {
    // MSWの初期化（開発環境のみ）
    if (process.env.NODE_ENV === "development") {
      import("@/mocks/browser").then(({ worker }) => {
        worker.start().then(() => {
          setIsInitialized(true);
        });
      });
    } else {
      setIsInitialized(true);
    }
  }, []);

  if (!isInitialized) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-400 mx-auto mb-4"></div>
          <p className="text-gray-600">読み込み中...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen to-green-50 py-8 bg-gray-50">
      <ElectricSimulationForm />
    </div>
  );
}
