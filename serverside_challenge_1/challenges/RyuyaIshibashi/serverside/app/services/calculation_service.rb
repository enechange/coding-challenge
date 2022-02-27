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
        simulations = simulate(ampere, amount)
  
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
        
      def simulate (ampere, amount)
        plans = Plan.basic_fee_ampere(ampere)

        simulations = []
        plans.each do |plan|
          price = 0
          if amount == 0 then
            price = plan.basic_fee.truncate
          else
            usage_charges = usage_charges(plan, amount)
            next unless usage_charges.present?
            price = calculate(plan.basic_fee, usage_charges, amount)
          end
        
          simulation_result = {
            provider_name: plan.company.name,
            plan_name: plan.name,
            price: price
          }

          simulations << simulation_result
        end
        simulations
      end

      def usage_charges (plan, amount)
        plan.usage_charges.where('usage_charges.from < ?', amount).order(:from)
      end

      def calculate (basic_fee, usage_charges, amount)
        price = basic_fee

        usage_charges.each do |usage_charge|
          if usage_charge.to.nil? || amount <= usage_charge.to then
            price += usage_charge.unit_price * (amount - usage_charge.from)
            break
          end

          price += usage_charge.unit_price * (usage_charge.to - usage_charge.from)
        end

        price.truncate
      end
  end
end
