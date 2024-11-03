require "rails_helper"

RSpec.describe Plan, type: :model do
  let(:provider) { create(:provider) }

  describe 'FactoryBot' do
    it '有効なファクトリを持つこと' do
      expect(build(:plan, provider: provider)).to be_valid
    end
  end

  describe 'Validation' do
    context 'name' do
      it '1文字の場合有効であること' do
        instance = build(:plan, provider: provider, name: 'a')
        expect(instance).to be_valid
      end

      it '255文字の場合有効であること' do
        instance = build(:plan, provider: provider, name: 'a' * 255)
        expect(instance).to be_valid
      end

      it 'nilの場合無効であること' do
        instance = build(:plan, provider: provider, name: nil)
        expect(instance).to be_invalid
        instance.errors[:name].include?("can't be blank")
      end

      it '空文字の場合無効であること' do
        instance = build(:plan, provider: provider, name: '')
        expect(instance).to be_invalid
        instance.errors[:name].include?("can't be blank")
      end

      it '256文字の場合無効であること' do
        instance = build(:plan, provider: provider, name: 'a' * 256)
        expect(instance).to be_invalid
        instance.errors[:name].include?("is too long (maximum is 255 characters)")
      end

      context 'uniqueness' do
        it 'providerが重複しない場合有効であること' do
          create(:plan, provider: provider, name: 'プラン')
          provider2 = create(:provider, name: '電力会社2')

          instance = build(:plan, provider: provider2, name: 'プラン')
          expect(instance).to be_valid
        end

        it '重複する場合無効であること' do
          create(:plan, provider: provider, name: 'プラン')

          instance = build(:plan, provider: provider, name: 'プラン')
          expect(instance).to be_invalid
          instance.errors[:name].include?("has already been taken")
        end
      end
    end

    context ':provider' do
      it 'nilの場合無効であること' do
        instance = build(:plan, provider: nil)
        expect(instance).to be_invalid
        instance.errors[:provider].include?("must exist")
      end
    end
  end

  describe 'associations' do
    let(:plan) { create(:plan, provider: provider) }

    context 'provider' do
      it '関連の設定が正しいか' do
        association = described_class.reflect_on_association(:provider)
        expect(association.macro).to eq :belongs_to
        expect(association.options[:dependent]).to be_nil
      end

      it '関連が参照できること' do
        expect(plan.provider).to eq provider
      end
    end

    context 'basic_prices' do
      it '関連の設定が正しいか' do
        association = described_class.reflect_on_association(:basic_prices)
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq :destroy
      end

      it '関連が参照できること' do
        basic_price = create(:basic_price, plan: plan)
        expect(plan.basic_prices).to eq [ basic_price ]
      end
    end

    context "measured_rates" do
      it "関連の設定が正しいか" do
        association = described_class.reflect_on_association(:measured_rates)
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq :destroy
      end

      it "関連が参照できること" do
        measured_rate = create(:measured_rate, plan: plan)
        expect(plan.measured_rates).to eq [ measured_rate ]
      end
    end
  end

  describe 'Methods' do
    describe 'check_parameters' do
      context 'amperage' do
        it '正常な場合、レスポンスにエラーが含まれないこと' do
          expect(Plan.check_parameters(20, 1000)).to be_empty
        end

        it 'エラーの場合、レスポンスにエラーが含まれること' do
          res = Plan.check_parameters(0, 1000)
          expect(res.size).to eq 1
          expect(res[0][:field]).to eq 'amperage'
          expect(res[0][:message]).to eq "#{BasicPrice::AMPERAGE_LIST.join('/')}のいずれかを指定してください。"
        end
      end

      context 'electricity_usage_kwh' do
        it 'エラーの場合、レスポンスにエラーが含まれること' do
          res = Plan.check_parameters(20, nil)
          expect(res.size).to eq 1
          expect(res[0][:field]).to eq 'electricity_usage_kwh'
          expect(res[0][:message]).to eq '整数を指定してください。'
        end
      end
    end

    describe 'calc_prices' do
      let(:provider1) { create(:provider, name: 'provider1') }
      let(:provider2) { create(:provider, name: 'provider2') }
      # plan1
      let(:plan1_provider1) { create(:plan, name: 'plan1', provider: provider1) }
      let(:plan1_amp_10) { create(:basic_price, plan: plan1_provider1, amperage: 10, price: 100.01) }
      let(:plan1_rate_0) { create(:measured_rate, plan: plan1_provider1, electricity_usage_min: 0, electricity_usage_max: nil, price: 10.01) }
      # plan2
      let(:plan2_provider2) { create(:plan, name: 'plan2', provider: provider2) }
      let(:plan2_amp_10) { create(:basic_price, plan: plan2_provider2, amperage: 10, price: 200.01) }
      let(:plan2_rate_0) { create(:measured_rate, plan: plan2_provider2, electricity_usage_min: 0, electricity_usage_max: nil, price: 20.03) }

      before do
        plan1_amp_10
        plan1_rate_0
        plan2_amp_10
        plan2_rate_0
      end

      context 'エラーの場合' do
        it 'レスポンスにエラーが設定されること' do
          res = Plan.calc_prices(0, 1)
          expect(res[:errors][:message]).to eq 'リクエストパラメーターが正しくありません。'
          expect(res[:errors][:details].size).to eq 1
          expect(res[:errors][:details][0][:field]).to eq 'amperage'
          expect(res[:errors][:details][0][:message]).to include "のいずれかを指定してください。"
        end
      end

      context '正常な場合' do
        it 'プランの料金が集計されること' do
          res = Plan.calc_prices(10, 1)

          expect(res[:errors]).to be_nil
          expect(res[:plans].size).to eq 2

          plans = res[:plans]
          expect(plans[0][:plan]).to eq plan1_provider1
          expect(plans[0][:provider]).to eq provider1
          expect(plans[0][:price]).to eq 110

          expect(plans[1][:plan]).to eq plan2_provider2
          expect(plans[1][:provider]).to eq provider2
          expect(plans[1][:price]).to eq 220
        end

        it '存在しないプランを指定した場合、レスポンスに含まれないこと' do
          plan2_amp_10.update!(amperage: 20)
          res = Plan.calc_prices(10, 1)

          expect(res[:errors]).to be_nil
          expect(res[:plans].size).to eq 1

          plans = res[:plans]
          expect(plans[0][:plan]).to eq plan1_provider1
          expect(plans[0][:provider]).to eq provider1
          expect(plans[0][:price]).to eq 110
        end
      end
    end
  end
end
