require "rails_helper"

RSpec.describe MeasuredRate, type: :model do
  let(:provider) { create(:provider) }
  let(:plan) { create(:plan, provider: provider) }

  describe 'FactoryBot' do
    it '有効なファクトリを持つこと' do
      expect(build(:measured_rate, plan: plan)).to be_valid
    end
  end

  describe "validation" do
    context "electricity_usage_min" do
      it 'nilの場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: nil)
        expect(instance).to be_invalid

        expect(instance.errors[:electricity_usage_min]).to eq [ "は数値で入力してください" ]
      end

      it 'マイナス値の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: -1)
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_min]).to eq [ 'は0以上の値にしてください' ]
      end

      it '空文字の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: '')
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_min]).to eq [ 'は数値で入力してください' ]
      end

      it '文字列の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: 'a')
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_min]).to eq [ 'は数値で入力してください' ]
      end

      it '1以上の場合有効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: 1)
        expect(instance).to be_valid
      end

      it '最大値の場合有効であること' do
        instance = build(:measured_rate, plan: plan,
                         electricity_usage_min: MeasuredRate::MAX_SMALL_INT_VALUE,
                         electricity_usage_max: MeasuredRate::MAX_SMALL_INT_VALUE)
        expect(instance).to be_valid
      end

      it '最大値を超える場合無効であること' do
        instance = build(:measured_rate, plan: plan,
                         electricity_usage_min: MeasuredRate::MAX_SMALL_INT_VALUE + 1,
                         electricity_usage_max: MeasuredRate::MAX_SMALL_INT_VALUE + 1)
        expect(instance).not_to be_valid
        expect(instance.errors[:electricity_usage_min]).to eq [ 'は32767以下の値にしてください' ]
      end
    end

    context "electricity_usage_max" do
      it 'nilの場合有効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_max: nil)
        expect(instance).to be_valid
        expect(instance.electricity_usage_max).to eq MeasuredRate::MAX_SMALL_INT_VALUE
      end

      it 'マイナス値の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_max: -1)
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_max]).to include('は1以上の値にしてください')
      end

      it '空文字の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_max: '')
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_max]).to eq [ 'は数値で入力してください' ]
      end

      it '文字列の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_max: 'a')
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_max]).to eq [ 'は数値で入力してください' ]
      end

      it '1以上の場合有効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_max: 1)
        expect(instance).to be_valid
      end

      it '最大値の場合有効であること' do
        instance = build(:measured_rate, plan: plan,
                         electricity_usage_min: MeasuredRate::MAX_SMALL_INT_VALUE,
                         electricity_usage_max: MeasuredRate::MAX_SMALL_INT_VALUE)
        expect(instance).to be_valid
      end

      it '最大値を超える場合無効であること' do
        instance = build(:measured_rate, plan: plan,
                         electricity_usage_min: MeasuredRate::MAX_SMALL_INT_VALUE + 1,
                         electricity_usage_max: MeasuredRate::MAX_SMALL_INT_VALUE + 1)
        expect(instance).not_to be_valid
        expect(instance.errors[:electricity_usage_max]).to eq [ 'は32767以下の値にしてください' ]
      end
    end

    context 'electricity_usage_min, electricity_usage_max' do
      it 'electricity_usage_max < electricity_usage_minの場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 1)
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_max]).to include("電気使用量の上限値を下限値より大きくしてください")
      end
    end

    context 'uniqueness' do
      context 'create時' do
        context 'electricity_usage_min' do
          it '他のrateに重複する場合無効であること' do
            create(:measured_rate, plan: plan, electricity_usage_min: 1, electricity_usage_max: 2)

            instance = build(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 3)
            expect(instance).to be_invalid
            expect(instance.errors[:electricity_usage_min]).to include('電気使用量の範囲が重複しています')
          end
        end

        context 'electricity_usage_max' do
          it '他のrateに重複する場合無効であること' do
            create(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 3)

            instance = build(:measured_rate, plan: plan, electricity_usage_min: 1, electricity_usage_max: 2)
            expect(instance).to be_invalid
            expect(instance.errors[:electricity_usage_max]).to include('電気使用量の範囲が重複しています')
          end
        end

        context 'electricity_usage_min, electricity_usage_maxのoverlap' do
          it '他のrateに重複する場合無効であること' do
            create(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 3)

            instance = build(:measured_rate, plan: plan, electricity_usage_min: 1, electricity_usage_max: 4)
            expect(instance).to be_invalid
            expect(instance.errors[:electricity_usage_max]).to include('電気使用量の範囲が重複しています')
          end
        end
      end

      context 'update時の自インスタンスとの重複' do
        context 'electricity_usage_min' do
          it '重複として判断されないこと' do
            instance = create(:measured_rate, plan: plan, electricity_usage_min: 1, electricity_usage_max: 2)
            instance.electricity_usage_min = 2
            instance.electricity_usage_max = 3

            expect(instance).to be_valid
          end
        end

        context 'electricity_usage_max' do
          it '重複として判断されないこと' do
            instance = create(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 3)
            instance.electricity_usage_min = 1
            instance.electricity_usage_max = 2

            expect(instance).to be_valid
          end
        end

        context 'electricity_usage_min, electricity_usage_maxのoverlap' do
          it '重複として判断されないこと' do
            instance = create(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 3)
            instance.electricity_usage_min = 1
            instance.electricity_usage_max = 4

            expect(instance).to be_valid
          end
        end
      end
    end

    context 'price' do
      it 'nilの場合無効であること' do
        instance = build(:measured_rate, plan: plan, price: nil)
        expect(instance).to be_invalid
        expect(instance.errors[:price]).to include("は数値で入力してください")
      end

      it '空文字の場合無効であること' do
        instance = build(:measured_rate, plan: plan, price: '')
        expect(instance).to be_invalid
        expect(instance.errors[:price]).to include("は数値で入力してください")
      end

      it '文字列の場合無効であること' do
        instance = build(:measured_rate, plan: plan, price: 'a')
        expect(instance).to be_invalid
        expect(instance.errors[:price]).to include("は数値で入力してください")
      end

      it '0の場合有効であること' do
        instance = build(:measured_rate, plan: plan, price: 0)
        expect(instance).to be_valid
      end

      it '99999.99の場合有効であること' do
        instance = build(:measured_rate, plan: plan, price: 99999.99)
        expect(instance).to be_valid
      end

      it '100000.00の場合無効であること' do
        instance = build(:measured_rate, plan: plan, price: 100000.00)
        expect(instance).to be_invalid
        expect(instance.errors[:price]).to include("は99999.99以下の値にしてください")
      end
    end

    context 'plan' do
      it 'nilの場合無効であること' do
        instance = build(:measured_rate, plan: nil)
        expect(instance).to be_invalid
        expect(instance.errors[:plan]).to include("を入力してください")
      end
    end
  end

  describe 'created' do
    context 'price' do
      it '小数点以下2桁のまで保存される' do
        instance = build(:measured_rate, plan: plan, price: 1.011)
        expect(instance.price).to eq 1.01
      end
    end
  end

  describe 'associations' do
    context 'plan' do
      it '関連の設定が正しいか' do
        association = described_class.reflect_on_association(:plan)
        expect(association.macro).to eq :belongs_to
        expect(association.options[:dependent]).to be_nil
      end

      it '関連が参照できること' do
        instance = create(:measured_rate, plan: plan)
        expect(instance.plan).to eq plan
      end
    end
  end

  describe 'Methods' do
    let(:provider1) { create(:provider, name: 'provider1') }
    let(:provider2) { create(:provider, name: 'provider2') }
    let(:plan1_provider1) { create(:plan, name: 'plan1', provider: provider1) }
    let(:plan2_provider1) { create(:plan, name: 'plan2', provider: provider1) }
    let(:plan3_provider2) { create(:plan, name: 'plan3', provider: provider2) }

    describe 'validate_electricity_usage?' do
      it '整数の場合エラーではないこと' do
        res = MeasuredRate.validate_electricity_usage?(1)
        expect(res[:is_error]).to be_falsey
        expect(res[:error_object]).to be_nil
      end

      it 'nilの場合エラーであること' do
        res = MeasuredRate.validate_electricity_usage?(nil)
        expect(res[:is_error]).to be_truthy
        expect(res[:error_object][:field]).to eq 'electricity_usage_kwh'
        expect(res[:error_object][:message]).to eq "整数を指定してください。"
      end

      it '実数の場合エラーであること' do
        res = MeasuredRate.validate_electricity_usage?(1.1)
        expect(res[:is_error]).to be_truthy
        expect(res[:error_object][:field]).to eq 'electricity_usage_kwh'
        expect(res[:error_object][:message]).to eq "整数を指定してください。"
      end
    end

    describe 'calc_row_price' do
      context 'instance.electricity_usage_min == 0の場合' do
        let(:measured_rate) { create(:measured_rate, plan: plan, electricity_usage_min: 0, electricity_usage_max: 10, price: 20.01) }
        before do
          measured_rate
        end

        it 'instance.electricity_usage_max < 引数の場合、価格計算が妥当であること' do
          expect(measured_rate.calc_row_price(11)).to eq 200.10
        end

        it '引数 == instance.electricity_usage_maxの場合、価格計算が妥当であること' do
          expect(measured_rate.calc_row_price(10)).to eq 200.10
        end

        it '引数 < instance.electricity_usage_maxの場合、価格計算が妥当であること' do
          expect(measured_rate.calc_row_price(9)).to eq 180.09
        end

        it '引数 == 1の場合、0となる' do
          expect(measured_rate.calc_row_price(1)).to eq 20.01
        end

        it '引数 == 0の場合、0となる' do
          expect(measured_rate.calc_row_price(0)).to eq 0
        end
      end

      context 'instance.electricity_usage_min > 0の場合' do
        let(:measured_rate) { create(:measured_rate, plan: plan, electricity_usage_min: 121, electricity_usage_max: 300, price: 10.01) }
        before do
          measured_rate
        end

        it 'instance.electricity_usage_max < 引数の場合、価格計算が妥当であること' do
          expect(measured_rate.calc_row_price(301)).to eq 1801.8
        end

        it '引数 == instance.electricity_usage_maxの場合、価格計算が妥当であること' do
          expect(measured_rate.calc_row_price(300)).to eq 1801.8
        end

        it '引数 < instance.electricity_usage_maxの場合、価格計算が妥当であること' do
          expect(measured_rate.calc_row_price(299)).to eq 1791.79
        end

        it '引数 == instance.electricity_usage_minの場合、価格計算が妥当であること' do
          expect(measured_rate.calc_row_price(121)).to eq 10.01
        end

        it '引数 == 0の場合、0となる' do
          expect(measured_rate.calc_row_price(0)).to eq 0
        end

        it '引数 == nilの場合、0となる' do
          expect(measured_rate.calc_row_price(nil)).to eq 0
        end
      end
    end

    describe 'electricity_usage_min_for_calc' do
      it 'electricity_usage_minが0の場合0を返す' do
        instance = create(:measured_rate, plan: plan1_provider1, electricity_usage_min: 0, electricity_usage_max: 10)
        expect(instance.send(:electricity_usage_min_for_calc)).to eq 0
      end

      it 'electricity_usage_minが0以外の場合electricity_usage_min - 1を返す' do
        instance = create(:measured_rate, plan: plan1_provider1, electricity_usage_min: 121, electricity_usage_max: 300)
        expect(instance.send(:electricity_usage_min_for_calc)).to eq 120
      end
    end

    describe 'calc_prices' do
      # plan1
      let(:plan1_rate_0_120) { create(:measured_rate, plan: plan1_provider1, electricity_usage_min: 0, electricity_usage_max: 120, price: 19.88) }
      let(:plan1_rate_121_300) { create(:measured_rate, plan: plan1_provider1, electricity_usage_min: 121, electricity_usage_max: 300, price: 26.48) }
      let(:plan1_rate_301) { create(:measured_rate, plan: plan1_provider1, electricity_usage_min: 301, electricity_usage_max: nil, price: 30.57) }
      # plan2
      let(:plan2_rate_0_120) { create(:measured_rate, plan: plan2_provider1, electricity_usage_min: 0, electricity_usage_max: 120, price: 10.0) }
      let(:plan2_rate_121_300) { create(:measured_rate, plan: plan2_provider1, electricity_usage_min: 121, electricity_usage_max: 300, price: 20.0) }
      let(:plan2_rate_301) { create(:measured_rate, plan: plan2_provider1, electricity_usage_min: 301, electricity_usage_max: nil, price: 30.0) }
      # plan3
      let(:plan3_rate_0) { create(:measured_rate, plan: plan3_provider2, electricity_usage_min: 0, electricity_usage_max: nil, price: 10.0) }

      context '無段階の価格表の場合' do
        before do
          plan3_rate_0
        end

        it '価格計算が妥当であること' do
          res = MeasuredRate.calc_prices(1000)

          expect(res.size).to eq 1
          expect(res[plan3_provider2.id][:price]).to eq 10000
        end
      end

      context '複数(3)段階の価格表の場合' do
        before do
          plan1_rate_0_120
          plan1_rate_121_300
          plan1_rate_301
        end

        context '1段階目の場合' do
          it '最小値の場合、価格計算が妥当であること' do
            res = MeasuredRate.calc_prices(1)

            expect(res.size).to eq 1
            expect(res[plan1_provider1.id][:price]).to eq 19.88
          end

          it '最大値の場合、価格計算が妥当であること' do
            res = MeasuredRate.calc_prices(120)

            expect(res.size).to eq 1
            expect(res[plan1_provider1.id][:price]).to eq 2385.6
          end
        end

        context '2段階目の場合' do
          it '最小値の場合、価格計算が妥当であること' do
            res = MeasuredRate.calc_prices(121)

            expect(res.size).to eq 1
            expect(res[plan1_provider1.id][:price]).to eq 2385.6 + 26.48
          end

          it '最大値の場合、価格計算が妥当であること' do
            res = MeasuredRate.calc_prices(300)

            expect(res.size).to eq 1
            expect(res[plan1_provider1.id][:price]).to eq 2385.6 + 4766.4
          end
        end

        context '3段階目の場合' do
          it '最小値の場合、価格計算が妥当であること' do
            res = MeasuredRate.calc_prices(301)

            expect(res.size).to eq 1
            expect(res[plan1_provider1.id][:price]).to eq 2385.6 + 4766.4 + 30.57
          end

          it '最小値以上の場合、価格計算が妥当であること' do
            res = MeasuredRate.calc_prices(500)

            expect(res.size).to eq 1
            expect(res[plan1_provider1.id][:price]).to eq 2385.6 + 4766.4 + 6114
          end
        end
      end

      context '複数のプランがある場合' do
        before do
          plan1_rate_0_120.update!(price: 20.0)
          plan1_rate_121_300.update!(price: 30.0)
          plan1_rate_301.update!(price: 40.0)
          plan2_rate_0_120
          plan2_rate_121_300
          plan2_rate_301
          plan3_rate_0
        end

        it '使用量の条件に合致する複数のプランが集計されること' do
          res = MeasuredRate.calc_prices(301)

          expect(res.size).to eq 3
          expect(res[plan1_provider1.id][:price]).to eq 7840
          expect(res[plan2_provider1.id][:price]).to eq 4830
          expect(res[plan3_provider2.id][:price]).to eq 3010
        end
      end
    end
  end
end
