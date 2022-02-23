class CalculationService

  AMPERE = { name: :ampere, japanese: '契約アンペア数', array: ['10', '15', '20', '30', '40', '50', '60'] }
  AMOUNT = { name: :amount, japanese: '使用料' }

  class << self
    def execute (params)
      begin
        # [1] 初期処理
        Rails.logger.info LogInfo.text('PROCESS_START')
  
        # [2] 入力チェック処理
        ampere = params[AMPERE[:name]]
        raise_bad_parameter(AMPERE[:japanese]) unless valid_ampere?(ampere, AMPERE[:array])
        ampere = ampere.to_i

        amount = params[AMOUNT[:name]]
        raise_bad_parameter(AMOUNT[:japanese]) unless valid_amount?(amount)
        amount = amount.to_i

        # [3] 検索処理
        basic_fees = BasicFee.where(ampere: ampere)
        simulations = simulate(basic_fees, amount)
  
        Rails.logger.info LogInfo.text('PROCESS_SEARCH', [simulations.count])     
  
        # [4] 編集返却処理 (入力チェックOK)
        result = { simulations: simulations }
        return result, :ok
  
             
      rescue CustomExceptions::BadParameter =>  e  
        # [4] 編集返却処理 (入力チェックNG)
        Rails.logger.warn LogInfo.text('INPUT_CHECK', [e.message])

        result = { error: LogInfo.hash('INPUT_CHECK', [e.message]) }
        return result, :bad_request

  
      rescue => e  
        # [4] 編集返却処理 (Exception発生)
        Rails.logger.error LogInfo.text('EXCEPTION')
        Rails.logger.error LogInfo.text('EXCEPTION_MESSAGE', [e.message])
        Rails.logger.error LogInfo.text('EXCEPTION_TRACE', [e.backtrace.join("\n")])

        result = { error: LogInfo.hash('EXCEPTION') }
        return result, :internal_server_error
        
  
      ensure
        # [5] 終了処理
        Rails.logger.info LogInfo.text('PROCESS_END')
      end
    end
  
    private
      def exist_and_int? (param)
        !!(param && param.match(/\A(0|[1-9][0-9]*)\z/))
      end
  
      def included_in_array? (param, ampere_array)
        ampere_array.include?(param)
      end
  
      def raise_bad_parameter (item_name)
        raise CustomExceptions::BadParameter, item_name
      end
  
      def valid_ampere? (ampere, ampere_array)
        exist_and_int?(ampere) && included_in_array?(ampere, ampere_array)
      end
  
      def valid_amount? (amount)
        exist_and_int?(amount)
      end
        
      def simulate (basic_fees, amount)
        simulations = []
        basic_fees.each do |basic_fee|
          
          # usage_charges = basic_fee.plan.usage_charges.order(:from).where('from <= ?', amount)

          unit_price = UsageCharge.unit_price(basic_fee.plan_id, amount)
          next if unit_price.nil?
          
          # price = calculate(basic_fee, usage_charges, amount)
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
 
      def calculate (basic_fee, usage_charges, amount)
        price = basic_fee.fee

        usage_charges.each do |usage_charge|
          if usage_charge.to.nil? || amount < usage_charge.to then
            price += usage_charge.unit_price * (amount - usage_charge.from)
            break
          end

          price += usage_charge.unit_price * (usage_charge.to - usage_charge.from)
        end

        price.truncate
      end
  end
end
