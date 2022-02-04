module CalculationHelper
  def ok_response (simulations)
    [{ result: 0, simulations: simulations }, :ok]
  end

  def ok_body (simulations)
    ok_response(simulations)[0].to_json
  end

  def bad_parameter_response (item_name)
    [{ result: 1, error: { code: "02001", message: "不正なリクエストです。項目=#{item_name}" } }, :bad_request]
  end

  def bad_parameter_body (item_name)
    bad_parameter_response(item_name)[0].to_json
  end

  def exception_response
    [{ result: 1, error: { code: "03001", message: "想定外のエラーが発生しました。" } }, :internal_server_error]
  end

  def exception_body
    exception_response[0].to_json
  end

  def simulation_result (provider_name, plan_name, price)
    {
      provider_name: provider_name,
      plan_name: plan_name,
      price: price
    }
  end
end
