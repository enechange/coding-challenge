require "rails_helper"

RSpec.describe MeasuredRate, type: :model do
  let(:electric_power_company) { create(:electric_power_company) }
  let(:plan) { create(:plan, electric_power_company: electric_power_company) }

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
        expect(instance.errors[:electricity_usage_min]).to include("is not a number")
      end

      it 'マイナス値の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: -1)
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_min]).to include("must be greater than or equal to 0")
      end

      it '空文字の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: '')
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_min]).to include("is not a number")
      end

      it '文字列の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: 'a')
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_min]).to include("is not a number")
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
        expect(instance.errors[:electricity_usage_min]).to include("must be less than or equal to 32767")
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
        expect(instance.errors[:electricity_usage_max]).to include("must be greater than or equal to 1")
      end

      it '空文字の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_max: '')
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_max]).to include("is not a number")
      end

      it '文字列の場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_max: 'a')
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_max]).to include("is not a number")
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
        expect(instance.errors[:electricity_usage_max]).to include("must be less than or equal to 32767")
      end
    end

    context 'electricity_usage_min, electricity_usage_max' do
      it 'electricity_usage_max < electricity_usage_minの場合無効であること' do
        instance = build(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 1)
        expect(instance).to be_invalid
        expect(instance.errors[:electricity_usage_max]).to include("must be greater than or equal to electricity_usage_min")
      end
    end

    context 'uniqueness' do
      context 'create時' do
        context 'electricity_usage_min' do
          it '他のrateに重複する場合無効であること' do
            create(:measured_rate, plan: plan, electricity_usage_min: 1, electricity_usage_max: 2)

            instance = build(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 3)
            expect(instance).to be_invalid
            expect(instance.errors[:electricity_usage_min]).to include("range overlaps with an existing range")
          end
        end

        context 'electricity_usage_max' do
          it '他のrateに重複する場合無効であること' do
            create(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 3)

            instance = build(:measured_rate, plan: plan, electricity_usage_min: 1, electricity_usage_max: 2)
            expect(instance).to be_invalid
            expect(instance.errors[:electricity_usage_max]).to include("range overlaps with an existing range")
          end
        end

        context 'electricity_usage_min, electricity_usage_maxのoverlap' do
          it '他のrateに重複する場合無効であること' do
            create(:measured_rate, plan: plan, electricity_usage_min: 2, electricity_usage_max: 3)

            instance = build(:measured_rate, plan: plan, electricity_usage_min: 1, electricity_usage_max: 4)
            expect(instance).to be_invalid
            expect(instance.errors[:electricity_usage_max]).to include("range overlaps with an existing range")
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
        instance.errors[:price].include?("can't be blank")
      end

      it '空文字の場合無効であること' do
        instance = build(:measured_rate, plan: plan, price: '')
        expect(instance).to be_invalid
        instance.errors[:price].include?("is not a number")
      end

      it '文字列の場合無効であること' do
        instance = build(:measured_rate, plan: plan, price: 'a')
        expect(instance).to be_invalid
        instance.errors[:price].include?("is not a number")
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
        instance.errors[:price].include?("must be less than or equal to 99999.99")
      end
    end

    context 'plan' do
      it 'nilの場合無効であること' do
        instance = build(:measured_rate, plan: nil)
        expect(instance).to be_invalid
        instance.errors[:plan].include?("must exist")
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
end
