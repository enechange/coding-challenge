require "spec_helper"
require 'bigdecimal'

describe CalculationService do

  describe "Private methods" do
    describe ".isExistingAndInt" do
      it "paramが存在しない場合falseを返す" do
        expect(CalculationService.send(:isExistingAndInt, nil)).to eq false
      end        
  
      it "paramが\"0\"以上の整数の場合trueを返す" do
        int_ary = [*(0..999)]
        int_ary.each do |int|
          expect(CalculationService.send(:isExistingAndInt, int.to_s)).to eq true
        end
      end
  
      it "paramが小数の場合falseを返す" do
        expect(CalculationService.send(:isExistingAndInt, "1.1")).to eq false
      end
  
      it "paramが空の場合falseを返す" do
        expect(CalculationService.send(:isExistingAndInt, "")).to eq false
      end
  
      it "paramが文字列の場合falseを返す" do
        expect(CalculationService.send(:isExistingAndInt, "a")).to eq false
      end
    end
  
    describe ".isValidAmpare" do
      let (:some_array) { ["1", "5", "10"]}
  
      it "paramがampare_arrayに含まれる場合、trueを返す" do
        expect(CalculationService.send(:isValidAmpare, "5", some_array)).to eq true    
      end
  
      it "paramがampare_arrayに含まれない場合、falseを返す" do
        expect(CalculationService.send(:isValidAmpare, "2", some_array)).to eq false      
      end
    end
  
    describe ".raiseBadParameter" do
      it "BadParameter Exceptionを発生させる" do
        expect do
          CalculationService.send(:raiseBadParameter, "hogehoge")
        end.to raise_error(CustomExceptions::BadParameter, "hogehoge")
      end
    end
  
    describe ".getAmpare" do
      let (:some_array) { ["1", "5", "10"]}
      it "存在、数値チェックでエラーの場合、BadParameter Exceptionを発生させる" do
        expect do
          CalculationService.send(:getAmpare, nil, "アンペア", some_array)
        end.to raise_error(CustomExceptions::BadParameter, "アンペア")
      end
  
      it "有効な値かチェックでエラーの場合、BadParameter Exceptionを発生させる" do
        expect do
          CalculationService.send(:getAmpare, "2", "アンペア", some_array)
        end.to raise_error(CustomExceptions::BadParameter, "アンペア")
      end
  
      it "アンペアが有効な値の場合、intに変換して返却" do
        expect(CalculationService.send(:getAmpare, "5", "アンペア", some_array)).to eq 5
      end
    end
  
    describe ".getAmount" do
      it "存在、数値チェックでエラーの場合、BadParameter Exceptionを発生させる" do
        expect do
          CalculationService.send(:getAmount, "a", "使用料")
        end.to raise_error(CustomExceptions::BadParameter, "使用料")
      end
  
      it "使用料が有効な値の場合、intに変換して返却" do
        expect(CalculationService.send(:getAmount, "3", "アンペア")).to eq 3
      end
    end

    describe ".getSimulations" do

      context "アンペアに該当する基本料金が0件の場合" do
        it "空の配列を返す" do
          expect(CalculationService.send(:getSimulations, BasicFee.none, 10)).to eq []          
        end
      end

      context "アンペアに該当する基本料金がある場合" do
        let! (:company_1) { FactoryBot.create(:company, name: "会社_1") }
        let! (:company_2) { FactoryBot.create(:company, name: "会社_2") }
        let! (:company_3) { FactoryBot.create(:company, name: "会社_3") }
  
        let! (:plan_1) { FactoryBot.create(:plan_itself, name: "プラン_1", company: company_1) }
        let! (:plan_2) { FactoryBot.create(:plan_itself, name: "プラン_2", company: company_2) }
        let! (:plan_3) { FactoryBot.create(:plan_itself, name: "プラン_3", company: company_3) }

        let! (:basic_fee_1) { FactoryBot.create(:basic_fee_itself, fee: BigDecimal("12.34"), plan: plan_1) }
        let! (:basic_fee_2) { FactoryBot.create(:basic_fee_itself, fee: BigDecimal("56.78"), plan: plan_2) }
        let! (:basic_fee_3) { FactoryBot.create(:basic_fee_itself, fee: BigDecimal("90.12"), plan: plan_3) }
        
        let (:basic_fees) { BasicFee.all }

        it "使用料が0の場合、料金は基本料金としてシミュレーション結果の配列を返す" do
          simulation_results = CalculationService.send(:getSimulations, basic_fees, 0)

          expect(simulation_results).to eq [
            simulation_result("会社_1", "プラン_1", 12), # 12.34の切り捨て
            simulation_result("会社_2", "プラン_2", 56), # 56.78の切り捨て
            simulation_result("会社_3", "プラン_3", 90)  # 90.12の切り捨て
          ]
        end

        it "使用料が0より大きい場合、正しいシミュレーション結果の配列を返す" do
          unit_prices = [BigDecimal("98.76"), BigDecimal("65.43"), BigDecimal("21.09")]
          allow(UsageCharge).to receive(:getUnitPrice).and_return(*unit_prices)
          
          simulation_results = CalculationService.send(:getSimulations, basic_fees, 3)

          expect(simulation_results).to eq [
            simulation_result("会社_1", "プラン_1", 308), # (12.34 + 98.76 * 3)の切り捨て
            simulation_result("会社_2", "プラン_2", 253), # (56.78 + 65.43 * 3)の切り捨て
            simulation_result("会社_3", "プラン_3", 153)  # (90.12 + 21.09 * 3)の切り捨て
          ]
        end
        it "（通常想定されないが）該当の従量料金レコードがないものはシミュレーション結果の配列から除外する" do
          unit_prices = [BigDecimal("98.76"), nil, BigDecimal("21.09")]
          allow(UsageCharge).to receive(:getUnitPrice).and_return(*unit_prices)
          
          simulation_results = CalculationService.send(:getSimulations, basic_fees, 3)

          expect(simulation_results).to eq [
            simulation_result("会社_1", "プラン_1", 308), # (12.34 + 98.76 * 3)の切り捨て
            simulation_result("会社_3", "プラン_3", 153)  # (90.12 + 21.09 * 3)の切り捨て
          ]
        end
      end
    end

    describe ".calculate" do
      subject { CalculationService.send(:calculate, BigDecimal("12.34"), BigDecimal("98.76"), 5) }
      it "Decimalで渡された値を用いて計算後、正しく整数値に切り捨てされること" do
        expect(subject).to eq 506 # (12.34 + 98.76 * 5)の切り捨て
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
  
        context "アンペアのパラメータが不正な場合" do
          subject { CalculationService.execute({}) }
          it "エラー時のログが適切に出力されること (Bad Parameter)" do
            bad_parameter_logs("アンペア")
            subject
          end
    
          it "エラー時の戻り値が返ること (Bad Parameter)" do
            expect(subject).to eq bad_parameter_response("アンペア")
          end
        end
  
        # 正常系：アンペアのパラメータが取りうる値の対として念のためテスト
        context "アンペアのパラメータが取りうる値でない場合" do
          subject { CalculationService.execute({ ampare: "11" }) }
          it "エラー時のログが適切に出力されること (Bad Parameter)" do
            bad_parameter_logs("アンペア")
            subject
          end
    
          it "エラー時の戻り値が返ること (Bad Parameter)" do
            expect(subject).to eq bad_parameter_response("アンペア")
          end
        end

        context "使用料のパラメータが不正な場合" do
          subject { CalculationService.execute({ ampare: "10" }) }
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
          allow(CalculationService).to receive(:getAmpare).and_raise(StandardError, "hogehoge")
        end
        subject { CalculationService.execute({ ampare: "10", amount: "5" }) }
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
        expect(Rails.logger).to receive(:info).with("code=01002; message='データ取得件数＝#{item_count}件'")
        expect(Rails.logger).to receive(:info).with("code=01003; message='処理を終了します。'")
      end

      subject { CalculationService.execute({ ampare: "10", amount: "10" }) }
  
      context "アンペアのパラメータが取りうる値の場合 -" do
        ampares = ['10', '15', '20', '30', '40', '50', '60']
        ampares.each do |ampare|
          context "アンペアが#{ampare}Aの場合" do
            subject { CalculationService.execute({ ampare: ampare, amount: "10" }) }
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
          allow(CalculationService).to receive(:getSimulations).and_return([])
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
          allow(CalculationService).to receive(:getSimulations).and_return(simulation_results)
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
          allow(CalculationService).to receive(:getSimulations).and_return(simulation_results)
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
