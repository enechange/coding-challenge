RSpec.describe BillingPlan do
  context 'when the plan is valid' do
    describe '東京電力エナジーパートナー 従量電灯B' do
      describe '10A' do
        cases = [
          {
            usage: 310
          }
        ]

        it '' do
          plan = BillingPlan.all.find { |p| p.provider_name == '東京電力エナジーパートナー' && p.plan_name == '従量電灯B' }
          expected = 286.00 + 19.88 * 120 + 26.00 * (300 - 120) + 30.00 * (310 - 300)
          actual = plan.calculate(10, 310)
          expect(actual).to eq(expected)
        end
      end
    end
  end
end
