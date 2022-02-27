require "spec_helper"

describe CalculationService do

  describe "Private methods" do
    describe ".exist_and_int?" do
      it "paramが存在しない場合falseを返す" do
        expect(CalculationService.send(:exist_and_int?, nil)).to eq false
      end        
  
      it "paramが\"0\"以上の整数の場合trueを返す" do
        int_ary = [*(0..999)]
        int_ary.each do |int|
          expect(CalculationService.send(:exist_and_int?, int.to_s)).to eq true
        end
      end
  
      it "paramが小数の場合falseを返す" do
        expect(CalculationService.send(:exist_and_int?, "1.1")).to eq false
      end
  
      it "paramが空の場合falseを返す" do
        expect(CalculationService.send(:exist_and_int?, "")).to eq false
      end
  
      it "paramが文字列の場合falseを返す" do
        expect(CalculationService.send(:exist_and_int?, "a")).to eq false
      end
    end
  
    describe ".included_in_array?" do
      let (:some_array) { ["1", "5", "10"]}
  
      it "paramがampere_arrayに含まれる場合、trueを返す" do
        expect(CalculationService.send(:included_in_array?, "5", some_array)).to eq true    
      end
  
      it "paramがampere_arrayに含まれない場合、falseを返す" do
        expect(CalculationService.send(:included_in_array?, "2", some_array)).to eq false      
      end
    end
  
    describe ".raise_bad_parameter" do
      it "BadParameter Exceptionを発生させる" do
        expect do
          CalculationService.send(:raise_bad_parameter, "hogehoge")
        end.to raise_error(CustomExceptions::BadParameter, "hogehoge")
      end
    end
  
    describe ".valid_ampere?" do
      let (:some_array) { ["1", "5", "10"]}
      it "存在、数値チェックでエラーの場合、falseを返却する" do
        expect(CalculationService.send(:valid_ampere?, nil, some_array)).to eq false
      end
  
      it "有効な値かチェックでエラーの場合、falseを返却する" do
        expect(CalculationService.send(:valid_ampere?, "2", some_array)).to eq false
      end
  
      it "契約アンペア数が有効な値の場合、trueを返却する" do
        expect(CalculationService.send(:valid_ampere?, "5", some_array)).to eq true
      end
    end
  
    describe ".valid_amount?" do
      it "存在、数値チェックでエラーの場合、falseを返却する" do
        expect(CalculationService.send(:valid_amount?, "a")).to eq false
      end
  
      it "使用料が有効な値の場合、intに変換して返却" do
        expect(CalculationService.send(:valid_amount?, "3")).to eq true
      end
    end

    describe ".simulate" do

      context "契約アンペア数に該当する基本料金が0件の場合" do
        it "空の配列を返す" do
          expect(CalculationService.send(:simulate, BasicFee.none, 10)).to eq []          
        end
      end

      context "契約アンペア数に該当する基本料金がある場合" do
        let! (:company_1) { FactoryBot.create(:company, name: "会社_1") }
        let! (:company_2) { FactoryBot.create(:company, name: "会社_2") }
        let! (:company_3) { FactoryBot.create(:company, name: "会社_3") }
        let! (:company_4) { FactoryBot.create(:company, name: "会社_4") }
  
        let! (:plan_1) { FactoryBot.create(:plan_itself, company: company_1, name: "プラン_1") }
        let! (:plan_2) { FactoryBot.create(:plan_itself, company: company_2, name: "プラン_2") }
        let! (:plan_3) { FactoryBot.create(:plan_itself, company: company_3, name: "プラン_3") }
        let! (:plan_4) { FactoryBot.create(:plan_itself, company: company_3, name: "プラン_4") }

        before do
          FactoryBot.create(:basic_fee_itself, plan: plan_1, ampere:"12", fee: "12.34")
          FactoryBot.create(:basic_fee_itself, plan: plan_2, ampere:"12", fee: "56.78")
          FactoryBot.create(:basic_fee_itself, plan: plan_3, ampere:"12", fee: "90.12")
          FactoryBot.create(:basic_fee_itself, plan: plan_4, ampere:"13", fee: "123.45")

          FactoryBot.create(:usage_charge)
        end
        
        let (:ampere) { 12 }
        let (:usage_charges) { UsageCharge.all }

        it "使用料が0の場合、契約アンペア数がマッチするプランに基づくシミュレーション結果の配列を返す（料金は基本料金）" do
          simulation_results = CalculationService.send(:simulate, ampere, 0)

          expect(simulation_results).to eq [
            simulation_result("会社_1", "プラン_1", 12), # 12.34の切り捨て
            simulation_result("会社_2", "プラン_2", 56), # 56.78の切り捨て
            simulation_result("会社_3", "プラン_3", 90)  # 90.12の切り捨て
          ]
        end

        it "使用料が0より大きい場合、契約アンペア数がマッチするプランに基づくシミュレーション結果の配列を返す" do
          allow(CalculationService).to receive(:usage_charges).and_return(usage_charges)
          
          prices = [308, 253, 153]
          allow(CalculationService).to receive(:calculate).and_return(*prices)
          
          simulation_results = CalculationService.send(:simulate, ampere, 3)

          expect(simulation_results).to eq [
            simulation_result("会社_1", "プラン_1", prices[0]),
            simulation_result("会社_2", "プラン_2", prices[1]),
            simulation_result("会社_3", "プラン_3", prices[2])
          ]
        end
        it "（通常想定されないが）該当の従量料金レコードがないものはシミュレーション結果の配列から除外する" do
          allow(CalculationService).to receive(:usage_charges).and_return(usage_charges, UsageCharge.none, usage_charges)
          
          prices = [308, 253]
          allow(CalculationService).to receive(:calculate).and_return(*prices)
          
          simulation_results = CalculationService.send(:simulate, ampere, 3)

          expect(simulation_results).to eq [
            simulation_result("会社_1", "プラン_1", prices[0]),
            simulation_result("会社_3", "プラン_3", prices[1])
          ]
        end
      end
    end

    describe ".usage_charges" do
      let! (:plan) { FactoryBot.create(:plan) }
      let! (:basic_fee) { FactoryBot.create(:basic_fee_itself, plan: plan) }

      context "プランに紐づく従量料金レコードが1件の場合" do
        let! (:usage_charge) { FactoryBot.create(:usage_charge_itself, plan: plan, from: "0.00", to: nil) }

        subject { CalculationService.send(:usage_charges, basic_fee, 1) }
        it "プランに紐づく1件の従量料金レコードを返す" do
          expect(subject.count).to eq 1
          expect(subject.first).to eq usage_charge
        end
      end

      context "プランに紐づく従量料金レコードが2件の場合" do
        let! (:usage_charge_1) { FactoryBot.create(:usage_charge_itself, plan: plan, from: "0.00", to: "12.00") }
        let! (:usage_charge_2) { FactoryBot.create(:usage_charge_itself, plan: plan, from: "12.00", to: nil) }

        context "使用料が2件目の従量料金レコードの使用料下限より小さい場合" do
          subject { CalculationService.send(:usage_charges, basic_fee, 11) }
          it "プランに紐づく1件目の従量料金レコードを返す" do
            expect(subject.count).to eq 1
            expect(subject.first).to eq usage_charge_1
          end
        end

        context "使用料が2件目の従量料金レコードの使用料下限と等しい場合" do
          subject { CalculationService.send(:usage_charges, basic_fee, 12) }
          it "プランに紐づく1件目の従量料金レコードを返す" do
            expect(subject.count).to eq 1
            expect(subject.first).to eq usage_charge_1
          end
        end

        context "使用料が2件目の従量料金レコードの使用料下限より大きい場合" do
          subject { CalculationService.send(:usage_charges, basic_fee, 13) }
          it "プランに紐づく2件の従量料金レコードを使用料下限の昇順に返す" do
            expect(subject.count).to eq 2
            expect(subject.first).to eq usage_charge_1
            expect(subject.second).to eq usage_charge_2
          end
        end
      end

      context "プランに紐づく従量料金レコードがN件の場合" do
        let! (:usage_charge_1) { FactoryBot.create(:usage_charge_itself, plan: plan, from: "0.00", to: "12.00") }
        let! (:usage_charge_2) { FactoryBot.create(:usage_charge_itself, plan: plan, from: "12.00", to: "23.00") }
        let! (:usage_charge_3) { FactoryBot.create(:usage_charge_itself, plan: plan, from: "23.00", to: "34.00") }
        let! (:usage_charge_4) { FactoryBot.create(:usage_charge_itself, plan: plan, from: "34.00", to: nil) }

        context "使用料がN件目の従量料金レコードの使用料下限より小さい場合" do
          subject { CalculationService.send(:usage_charges, basic_fee, 33) }
          it "プランに紐づくN-1件の従量料金レコードを使用料下限の昇順に返す" do
            expect(subject.count).to eq 3
            expect(subject.first).to eq usage_charge_1
            expect(subject.second).to eq usage_charge_2
            expect(subject.third).to eq usage_charge_3
          end
        end

        context "使用料がN件目の従量料金レコードの使用料下限と等しい場合" do
          subject { CalculationService.send(:usage_charges, basic_fee, 34) }
          it "プランに紐づくN-1件の使用料レコードを使用料下限の昇順に返す" do
            expect(subject.count).to eq 3
            expect(subject.first).to eq usage_charge_1
            expect(subject.second).to eq usage_charge_2
            expect(subject.third).to eq usage_charge_3
          end
        end

        context "使用料がN件目の従量料金レコードの使用料下限より大きい場合" do
          subject { CalculationService.send(:usage_charges, basic_fee, 35) }
          it "プランに紐づくN件の従量料金レコードを使用料下限の昇順に返す" do
            expect(subject.count).to eq 4
            expect(subject.first).to eq usage_charge_1
            expect(subject.second).to eq usage_charge_2
            expect(subject.third).to eq usage_charge_3
            expect(subject.fourth).to eq usage_charge_4
          end
        end
      end

      context "(通常想定されないが)使用料未満の使用料下限を持つ従量料金レコードがない場合" do
        let! (:usage_charge) { FactoryBot.create(:usage_charge_itself, plan: plan, from: "12.00", to: "23.00") }

        subject { CalculationService.send(:usage_charges, basic_fee, 12) }
        it "0件の従量料金レコードを返す" do
          expect(subject.count).to eq 0
        end
      end
    end

    describe ".calculate" do
      let! (:plan) { FactoryBot.create(:plan) }
      let! (:basic_fee) { FactoryBot.create(:basic_fee_itself, plan: plan, fee: "12.34") }
      let (:usage_charges) { UsageCharge.all }

      context "該当する従量料金レコードが1件のみの場合" do
        before do
          FactoryBot.create(:usage_charge_itself, plan: plan, from: "0.00", to: nil, unit_price: "56.78")
        end
        subject { CalculationService.send(:calculate, basic_fee, usage_charges, 5) }
        it "Decimalで渡された値を用いて計算後、正しく整数値に切り捨てされること" do
          expect(subject).to eq 296 # (12.34 + 56.78 * 5)の切り捨て
        end
      end

      context "該当する従量料金レコードが2件の場合" do
        before do
          FactoryBot.create(:usage_charge_itself, plan: plan, from: "0.00", to: "12.34", unit_price: "56.78")
        end
        
        context "2件目の使用料上限なしの場合" do
          before do
            FactoryBot.create(:usage_charge_itself, plan: plan, from: "12.34", to: nil, unit_price: "90.12")
          end
          subject { CalculationService.send(:calculate, basic_fee, usage_charges, 20) }
          it "Decimalで渡された値を用いて計算後、正しく整数値に切り捨てされること" do
            # 基本料: 12.34
            # 使用料：(56.78 * 12.34) + (90.12 * (20-12.34)) = 700.6652 + 690.3192 = 1390.9844
            expect(subject).to eq 1403
          end
        end

        context "2件目の使用料上限ありの場合" do
          before do
            FactoryBot.create(:usage_charge_itself, plan: plan, from: "12.34", to: "56.78", unit_price: "90.12")
          end
          context "通常ケース" do
            subject { CalculationService.send(:calculate, basic_fee, usage_charges, 20) }
            it "Decimalで渡された値を用いて計算後、正しく整数値に切り捨てされること" do
              # 基本料: 12.34
              # 使用料：(56.78 * 12.34) + (90.12 * (20-12.34)) = 1390.9844
              expect(subject).to eq 1403
            end
          end
          context "使用料が2件目の使用料上限と等しい場合" do
            subject { CalculationService.send(:calculate, basic_fee, usage_charges, 56.78) }
            it "Decimalで渡された値を用いて計算後、正しく整数値に切り捨てされること" do
              # 基本料: 12.34
              # 使用料：(56.78 * 12.34) + (90.12 * (56.78-12.34)) = 4705.598
              expect(subject).to eq 4717
            end
          end
        end
      end

      context "該当する従量料金レコードがN件の場合" do
        before do
          FactoryBot.create(:usage_charge_itself, plan: plan, from: "0.00", to: "12.34", unit_price: "56.78")
          FactoryBot.create(:usage_charge_itself, plan: plan, from: "12.34", to: "56.78", unit_price: "90.12")
          FactoryBot.create(:usage_charge_itself, plan: plan, from: "56.78", to: "90.12", unit_price: "123.45")
        end
        
        context "N件目の使用料上限なしの場合" do
          before do
            FactoryBot.create(:usage_charge_itself, plan: plan, from: "90.12", to: nil, unit_price: "234.56")
          end
          subject { CalculationService.send(:calculate, basic_fee, usage_charges, 100) }
          it "Decimalで渡された値を用いて計算後、正しく整数値に切り捨てされること" do
            # 基本料: 12.34
            # 使用料：(56.78 * 12.34) + (90.12 * (56.78-12.34)) + (123.45 * (90.12 - 56.78)) + (234.56 * (100 - 90.12)) = 11138.8738
            expect(subject).to eq 11151
          end
        end

        context "N件目の使用料上限ありの場合" do
          before do
            FactoryBot.create(:usage_charge_itself, plan: plan, from: "90.12", to: "123.45", unit_price: "234.56")
          end
          subject { CalculationService.send(:calculate, basic_fee, usage_charges, 100) }
          it "Decimalで渡された値を用いて計算後、正しく整数値に切り捨てされること" do
            # 基本料: 12.34
            # 使用料：(56.78 * 12.34) + (90.12 * (56.78-12.34)) + (123.45 * (90.12 - 56.78)) + (234.56 * (100 - 90.12)) = 11138.8738
            expect(subject).to eq 11151
          end
        end
      end
    end
  end

  describe "execute" do
    context "異常系" do
      context "Bad Parameter" do
        def bad_parameter_logs (item_name)
          expect(Rails.logger).to receive(:info).with("code=01001; message='処理を開始します。'")
          expect(Rails.logger).to receive(:warn).with("code=02001; message='不正なリクエストです。項目=#{item_name}'")
          expect(Rails.logger).to receive(:info).with("code=01003; message='処理を終了します。'")
        end
  
        context "契約アンペア数のパラメータが不正な場合" do
          subject { CalculationService.execute({}) }
          it "エラー時のログが適切に出力されること (Bad Parameter)" do
            bad_parameter_logs("契約アンペア数")
            subject
          end
    
          it "エラー時の戻り値が返ること (Bad Parameter)" do
            expect(subject).to eq bad_parameter_response("契約アンペア数")
          end
        end
  
        # 正常系：契約アンペア数のパラメータが取りうる値の対として念のためテスト
        context "契約アンペア数のパラメータが取りうる値でない場合" do
          subject { CalculationService.execute({ ampere: "11" }) }
          it "エラー時のログが適切に出力されること (Bad Parameter)" do
            bad_parameter_logs("契約アンペア数")
            subject
          end
    
          it "エラー時の戻り値が返ること (Bad Parameter)" do
            expect(subject).to eq bad_parameter_response("契約アンペア数")
          end
        end

        context "使用料のパラメータが不正な場合" do
          subject { CalculationService.execute({ ampere: "10" }) }
          it "エラー時のログが適切に出力されること (Bad Parameter)" do
            bad_parameter_logs("使用料")
            subject
          end
    
          it "エラー時の戻り値が返ること (Bad Parameter)" do
            expect(subject).to eq bad_parameter_response("使用料")
          end
        end
      end
      
      context "Exception" do
        def exception_logs (message)
          expect(Rails.logger).to receive(:info).with("code=01001; message='処理を開始します。'")
          expect(Rails.logger).to receive(:error).with("code=03001; message='想定外のエラーが発生しました。'")
          expect(Rails.logger).to receive(:error).with("code=03002; message='エラーメッセージ=\"#{message}\"'")
          expect(Rails.logger).to receive(:error).with(/code=03003; message='スタックトレース=".*'/)
          expect(Rails.logger).to receive(:info).with("code=01003; message='処理を終了します。'")
        end

        before do
          # 内部のメソッドで例外を発生
          allow(CalculationService).to receive(:valid_ampere?).and_raise(StandardError, "hogehoge")
        end
        subject { CalculationService.execute({ ampere: "10", amount: "5" }) }
        it "エラー時のログが適切に出力されること (Exception)" do
          exception_logs("hogehoge")
          subject
        end

        it "エラー時の戻り値が返ること (Exception)" do
          expect(subject).to eq exception_response
        end
    end
    end
  
    context "正常系" do
      def ok_logs (item_count)
        expect(Rails.logger).to receive(:info).with("code=01001; message='処理を開始します。'")
        expect(Rails.logger).to receive(:info).with("code=01002; message='データ取得件数=#{item_count}件'")
        expect(Rails.logger).to receive(:info).with("code=01003; message='処理を終了します。'")
      end

      subject { CalculationService.execute({ ampere: "10", amount: "10" }) }
  
      context "契約アンペア数のパラメータが取りうる値の場合 -" do
        amperes = ['10', '15', '20', '30', '40', '50', '60']
        amperes.each do |ampere|
          context "契約アンペア数が#{ampere}Aの場合" do
            subject { CalculationService.execute({ ampere: ampere, amount: "10" }) }
            it "正常時のログが適切に出力されること" do
              ok_logs(0)
              subject
            end
      
            it "正常時の戻り値が返ること" do
              expect(subject).to eq ok_response([])
            end            
          end
        end
      end

      context "戻り値が0件の場合" do
        before do
          allow(CalculationService).to receive(:simulate).and_return([])
        end

        it "正常時のログが適切に出力されること" do
          ok_logs(0)
          subject
        end

        it "正常時の戻り値が返ること" do
          expect(subject).to eq ok_response([])
        end
      end

      context "戻り値が1件の場合" do
        let (:simulation_results) { [simulation_result("会社_1", "プラン_1", 100)] }
        before do
          allow(CalculationService).to receive(:simulate).and_return(simulation_results)
        end
  
        it "正常時のログが適切に出力されること" do
          ok_logs(1)
          subject
        end
  
        it "正常時の戻り値が返ること" do
          expect(subject).to eq ok_response(simulation_results)
          subject
        end
      end

      context "戻り値がN件の場合" do
        let (:simulation_results) {
          [
            simulation_result("会社_1", "プラン_1", 100),
            simulation_result("会社_2", "プラン_2", 200),
            simulation_result("会社_3", "プラン_3", 300),
            simulation_result("会社_4", "プラン_4", 400)
          ]
        }
        before do
          allow(CalculationService).to receive(:simulate).and_return(simulation_results)
        end
  
        it "正常時のログが適切に出力されること" do
          ok_logs(4)
          subject
        end
  
        it "正常時の戻り値が返ること" do
          expect(subject).to eq ok_response(simulation_results)
          subject
        end
      end
    end
  end
end
