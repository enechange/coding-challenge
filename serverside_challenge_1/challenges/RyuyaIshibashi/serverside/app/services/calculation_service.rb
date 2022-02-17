class CalculationService

  AMPARE = { name: :ampere, japanese: '契約アンペア数', array: ['10', '15', '20', '30', '40', '50', '60'] }
  AMOUNT = { name: :amount, japanese: '使用料' }

  class << self
    def execute (params)
      begin
        # [1] 初期処理
        Rails.logger.info LogInfo.getText('PROCESS_START')
  
        # [2] 入力チェック処理
        ampere = getAmpere(params[AMPARE[:name]], AMPARE[:japanese], AMPARE[:array])
        amount = getAmount(params[AMOUNT[:name]], AMOUNT[:japanese])
        
        # [3] 検索処理
        basic_fees = BasicFee.where(ampere: ampere)
        simulations = getSimulations(basic_fees, amount)
  
        Rails.logger.info LogInfo.getText('PROCESS_SEARCH', [simulations.count])     
  
        # [4] 編集返却処理 (入力チェックOK)
        result = {
          result: 0,
          simulations: simulations
        }
        return result, :ok
  
             
      rescue CustomExceptions::BadParameter =>  e  
        # [4] 編集返却処理 (入力チェックNG)
        result = { 
          result: 1,
          error: LogInfo.getHash('INPUT_CHECK', [e.message])
        }

        Rails.logger.warn LogInfo.getText('INPUT_CHECK', [e.message])

        return result, :bad_request


  
      rescue => e  
        # [4] 編集返却処理 (Exception発生)
        result = { 
          result: 1,
          error: LogInfo.getHash('EXCEPTION')
        }

        Rails.logger.error LogInfo.getText('EXCEPTION')
        Rails.logger.error LogInfo.getText('EXCEPTION_MESSAGE', [e.message])
        Rails.logger.error LogInfo.getText('EXCEPTION_TRACE', [e.backtrace.join("\n")])

        return result, :internal_server_error
        
  
      ensure
        # [5] 終了処理
        Rails.logger.info LogInfo.getText('PROCESS_END')
      end
    end
  
    private
      def isExistingAndInt(param)
        if (!param || !param.match(/\A(0|[1-9][0-9]*)\z/))
          return false
        end
        true
      end
  
      def isValidAmpere(param, ampere_array)
        if (!ampere_array.include?(param))
          return false
        end
        true
      end
  
      def raiseBadParameter (item_name)
        raise CustomExceptions::BadParameter, item_name
      end
  
      def getAmpere(ampere, item_name, ampere_array)
        if (
        # 契約アンペア数の存在、数値チェック
        !isExistingAndInt(ampere) || 
        # 契約アンペア数が有効な値かチェック
        !isValidAmpere(ampere, ampere_array))
          raiseBadParameter(item_name)
        end
          
        ampere = ampere.to_i
      end
  
      def getAmount (amount, item_name)
        # 使用料の存在、数値チェック
        if (!isExistingAndInt(amount))
          raiseBadParameter(item_name)
        end
  
        amount = amount.to_i
      end
        
      def getSimulations (basic_fees, amount)
        simulations = []
        basic_fees.each do |basic_fee|
          unit_price = UsageCharge.getUnitPrice(basic_fee.plan_id, amount)
          next if unit_price.nil?
          
          price = calculate(basic_fee.fee, unit_price, amount)
      
          simulation_result = {
            provider_name: basic_fee.company_name,
            plan_name: basic_fee.plan_name,
            price: price
          }
  
          simulations << simulation_result
        end
        simulations
      end
  
      def calculate (fee, unit_price, amount)
        (fee + unit_price * amount).truncate
      end
  end
end
