# frozen_string_literal: true

require "rails_helper"

RSpec.describe FetchElectricityChargeService, type: :service do
  subject { described_class.new(simulate_form) }

  describe "#call" do
    context "when ampere is 30 and usage is 120" do
      let(:simulate_form) { Form::Simulate.new({ ampere: 30.to_s, usage: 120.to_s }) }

      it "returns the result of electricity charge" do
        results = subject.call
        metered_lighting_b = results.find { |item| item[:plan_name] == "従量電灯B" }
        expect(metered_lighting_b).to eq(
          status:        :success,
          provider_name: "東京電力エナジーパートナー",
          plan_name:     "従量電灯B",
          price:         3243.6
        )

        standard_s = results.find { |item| item[:plan_name] == "スタンダードS" }
        expect(standard_s).to eq(
          status:        :success,
          provider_name: "東京電力エナジーパートナー",
          plan_name:     "スタンダードS",
          price:         4511.25
        )

        zuttomo1 = results.find { |item| item[:plan_name] == "ずっとも電気1" }
        expect(zuttomo1).to eq(
          status:        :success,
          provider_name: "東京ガス",
          plan_name:     "ずっとも電気1",
          price:         3698.4
        )

        ouchi = results.find { |item| item[:plan_name] == "おうちプラン" }
        expect(ouchi).to eq(
          status:        :success,
          provider_name: "Looopでんき",
          plan_name:     "おうちプラン",
          price:         3456
        )
      end
    end

    context "when ampere is 10 and usage is 121" do
      let(:simulate_form) { Form::Simulate.new({ ampere: 10.to_s, usage: 121.to_s }) }

      it "returns the result of electricity charge" do
        results = subject.call
        metered_lighting_b = results.find { |item| item[:plan_name] == "従量電灯B" }
        expect(metered_lighting_b).to eq(
          status:        :success,
          provider_name: "東京電力エナジーパートナー",
          plan_name:     "従量電灯B",
          price:         2698.08
        )


        standard_s = results.find { |item| item[:plan_name] == "スタンダードS" }
        expect(standard_s).to eq(
          status:        :success,
          provider_name: "東京電力エナジーパートナー",
          plan_name:     "スタンダードS",
          price:         3924.15
        )

        zuttomo1 = results.find { |item| item[:plan_name] == "ずっとも電気1" }
        expect(zuttomo1).to eq(
          status:        :error,
          provider_name: "東京ガス",
          plan_name:     "ずっとも電気1",
          message:       "Basic charge not found for 10A"
        )

        ouchi = results.find { |item| item[:plan_name] == "おうちプラン" }
        expect(ouchi).to eq(
          status:        :success,
          provider_name: "Looopでんき",
          plan_name:     "おうちプラン",
          price:         3484.8
        )
      end
    end

    context "when ampere is 30 and usage is 300" do
      let(:simulate_form) { Form::Simulate.new({ ampere: 30.to_s, usage: 300.to_s }) }

      it "returns the result of electricity charge" do
        results = subject.call
        metered_lighting_b = results.find { |item| item[:plan_name] == "従量電灯B" }
        expect(metered_lighting_b).to eq(
          status:        :success,
          provider_name: "東京電力エナジーパートナー",
          plan_name:     "従量電灯B",
          price:         8010
        )


        standard_s = results.find { |item| item[:plan_name] == "スタンダードS" }
        expect(standard_s).to eq(
          status:        :success,
          provider_name: "東京電力エナジーパートナー",
          plan_name:     "スタンダードS",
          price:         11063.25
        )

        zuttomo1 = results.find { |item| item[:plan_name] == "ずっとも電気1" }
        expect(zuttomo1).to eq(
          status:        :success,
          provider_name: "東京ガス",
          plan_name:     "ずっとも電気1",
          price:         7992.6
        )

        ouchi = results.find { |item| item[:plan_name] == "おうちプラン" }
        expect(ouchi).to eq(
          status:        :success,
          provider_name: "Looopでんき",
          plan_name:     "おうちプラン",
          price:         8640
        )
      end
    end

    context "when ampere is 60 and usage is 351" do
      let(:simulate_form) { Form::Simulate.new({ ampere: 60.to_s, usage: 351.to_s }) }

      it "returns the result of electricity charge" do
        results = subject.call
        metered_lighting_b = results.find { |item| item[:plan_name] == "従量電灯B" }
        expect(metered_lighting_b).to eq(
          status:        :success,
          provider_name: "東京電力エナジーパートナー",
          plan_name:     "従量電灯B",
          price:         10427.07
        )


        standard_s = results.find { |item| item[:plan_name] == "スタンダードS" }
        expect(standard_s).to eq(
          status:        :success,
          provider_name: "東京電力エナジーパートナー",
          plan_name:     "スタンダードS",
          price:         14063.49
        )

        zuttomo1 = results.find { |item| item[:plan_name] == "ずっとも電気1" }
        expect(zuttomo1).to eq(
          status:        :success,
          provider_name: "東京ガス",
          plan_name:     "ずっとも電気1",
          price:         10071.01
        )

        ouchi = results.find { |item| item[:plan_name] == "おうちプラン" }
        expect(ouchi).to eq(
          status:        :success,
          provider_name: "Looopでんき",
          plan_name:     "おうちプラン",
          price:         10108.8
        )
      end
    end
  end
end
