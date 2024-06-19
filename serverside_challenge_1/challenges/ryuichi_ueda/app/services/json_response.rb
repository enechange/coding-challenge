# frozen_string_literal: true

class JsonResponse
  def self.unprocessable_entity(message)
    {
      status: :unprocessable_entity,
      json: {
        status: 'error',
        message:,
        data: {}
      }
    }
  end

  def self.ok(generated_data)
    {
      status: :ok,
      json: {
        status: 'success',
        message: '料金情報の取得に成功しました。',
        data: generated_data
      }
    }
  end
end
