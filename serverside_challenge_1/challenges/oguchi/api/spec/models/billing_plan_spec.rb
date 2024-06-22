RSpec.describe BillingPlan do
  context 'when the plan is valid' do
    describe '東京電力エナジーパートナー 従量電灯B' do
      describe '10A' do
        cases = [
          {
            plan: BillingPlan.all.find { |p| p.provider_name == '東京電力エナジーパートナー' && p.plan_name == '従量電灯B' },
            amperage: 10,
            usage: 30,
            expected: 286.00 + 19.88 * 30,
          },
          {
            plan: BillingPlan.all.find { |p| p.provider_name == '東京電力エナジーパートナー' && p.plan_name == '従量電灯B' },
            amperage: 10,
            usage: 310,
            expected: 286.00 + 19.88 * 120 + 26.48 * (300 - 120) + 30.57 * (310 - 300),
          },
        ]

        cases.each do |c|
          actual = c[:plan].calculate(c[:amperage], c[:usage])
          it { expect(actual).to eq(c[:expected]) }
        end
      end
    end
  end
end
