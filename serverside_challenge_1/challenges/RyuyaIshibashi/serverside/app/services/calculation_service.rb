class CalculationService

  AMPARE = { name: :ampare, japanese: 'アンペア', array: ['10', '15', '20', '30', '40', '50', '60'] }
  AMOUNT = { name: :amount, japanese: '使用料' }

  class << self
    def execute (params)
      begin
        Rails.logger.info LogInfo.getText('PROCESS_START')
  
        ampare = getAmpare(params[AMPARE[:name]], AMPARE[:japanese], AMPARE[:array])
        amount = getAmount(params[AMOUNT[:name]], AMOUNT[:japanese])
        
        basic_fees = BasicFee.search_with_ampare(ampare)

        simulations = getSimulations(basic_fees, amount)
  
        Rails.logger.info LogInfo.getText('PROCESS_SEARCH', [simulations.count])     
  
        result = {
          result: 0,
          simulations: simulations
        }
        return result, :ok
  
             
      rescue CustomExceptions::BadParameter =>  e
        Rails.logger.warn LogInfo.getText('INPUT_CHECK', [e.message])
  
        result = { 
          result: 1,
          error: LogInfo.getHash('INPUT_CHECK', [e.message])
        }
        return result, :bad_request
      
  
      rescue => e
        Rails.logger.error LogInfo.getText('EXCEPTION')
        Rails.logger.error LogInfo.getText('EXCEPTION_MESSAGE', [e.message])
        Rails.logger.error LogInfo.getText('EXCEPTION_TRACE', [e.backtrace.join("\n")])
  
        result = { 
          result: 1,
          error: LogInfo.getHash('EXCEPTION')
        }
        return result, :internal_server_error
  
  
      ensure
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
  
      def isValidAmpare(param, ampare_array)
        if (!ampare_array.include?(param))
          return false
        end
        true
      end
  
      def raiseBadParameter (item_name)
        raise CustomExceptions::BadParameter, item_name
      end
  
      def getAmpare(ampare, item_name, ampare_array)
        if (
        # アンペアの存在、数値チェック
        !isExistingAndInt(ampare) || 
        # アンペアが有効な値かチェック
        !isValidAmpare(ampare, ampare_array))
          raiseBadParameter(item_name)
        end
          
        ampare = ampare.to_i
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
            provider_name: basic_fee.getCompanyName,
            plan_name: basic_fee.getPlanName,
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
