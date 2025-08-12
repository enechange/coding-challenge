import { electricSimulationFormSchema } from "@/schemas";

describe("Zodスキーマテスト", () => {
  describe("electricSimulationFormSchema", () => {
    it("有効なデータがバリデーションを通過する", () => {
      const validData = {
        postalCodeFirst: "130",
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 10000,
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(validData);
      expect(result.success).toBe(true);
    });

    it("郵便番号前半が無効な場合は失敗する", () => {
      const invalidData = {
        postalCodeFirst: "13", // 3桁未満は無効
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 10000,
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(invalidData);
      expect(result.success).toBe(false);
    });

    it("郵便番号後半が無効な場合は失敗する", () => {
      const invalidData = {
        postalCodeFirst: "130",
        postalCodeSecond: "001", // 4桁未満は無効
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 10000,
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(invalidData);
      expect(result.success).toBe(false);
    });

    it("電気代が低すぎる場合は失敗する（1000円未満）", () => {
      const invalidData = {
        postalCodeFirst: "130",
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 500, // 1000円未満は無効
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(invalidData);
      expect(result.success).toBe(false);
    });

    it("メールアドレス形式が無効な場合は失敗する", () => {
      const invalidData = {
        postalCodeFirst: "130",
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 10000,
        email: "invalid-email", // 無効なメール
      };

      const result = electricSimulationFormSchema.safeParse(invalidData);
      expect(result.success).toBe(false);
    });

    it("関西電力従量電灯Aでは契約容量が不要", () => {
      const validData = {
        postalCodeFirst: "567",
        postalCodeSecond: "8901",
        powerCompany: "kansai-electric" as const,
        plan: "kansai-juryou-a" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 10000,
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(validData);
      expect(result.success).toBe(true);
    });

    it("東京電力従量電灯Bでは契約容量が必要", () => {
      const invalidData = {
        postalCodeFirst: "130",
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        // contractCapacity が必要だが未設定
        currentElectricBill: 10000,
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(invalidData);
      expect(result.success).toBe(false);
    });

    it("東京電力従量電灯Cでは契約容量が必要", () => {
      const invalidData = {
        postalCodeFirst: "130",
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-c" as const,
        // contractCapacity が必要だが未設定
        currentElectricBill: 10000,
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(invalidData);
      expect(result.success).toBe(false);
    });

    it("関西電力従量電灯Bでは契約容量が必要", () => {
      const invalidData = {
        postalCodeFirst: "567",
        postalCodeSecond: "8901",
        powerCompany: "kansai-electric" as const,
        plan: "kansai-juryou-b" as const,
        // contractCapacity が必要だが未設定
        currentElectricBill: 10000,
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(invalidData);
      expect(result.success).toBe(false);
    });

    it("郵便番号形式が正しく検証される", () => {
      const validData = {
        postalCodeFirst: "130",
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 10000,
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(validData);
      expect(result.success).toBe(true);
      if (result.success) {
        expect(result.data.postalCodeFirst).toBe("130");
        expect(result.data.postalCodeSecond).toBe("0012");
      }
    });

    it("メールアドレス形式が正しく検証される", () => {
      const validData = {
        postalCodeFirst: "130",
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 10000,
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(validData);
      expect(result.success).toBe(true);
      if (result.success) {
        expect(result.data.email).toBe("test@example.com");
      }
    });

    it("現在の電気代の範囲が正しく検証される", () => {
      const validData = {
        postalCodeFirst: "130",
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 1000, // 最小値
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(validData);
      expect(result.success).toBe(true);
    });

    it("現在の電気代が最小値未満の場合は失敗する", () => {
      const invalidData = {
        postalCodeFirst: "130",
        postalCodeSecond: "0012",
        powerCompany: "tokyo-electric" as const,
        plan: "tokyo-juryou-b" as const,
        contractCapacity: "30A" as const,
        currentElectricBill: 999, // 1000円未満
        email: "test@example.com",
      };

      const result = electricSimulationFormSchema.safeParse(invalidData);
      expect(result.success).toBe(false);
    });
  });
});
