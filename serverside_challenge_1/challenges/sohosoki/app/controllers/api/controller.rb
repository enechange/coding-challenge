module Api
  class Controller < ActionController::API
    def ok(data = nil)
      render json: {
        status: 'OK',
        data: data
      }
    end

    def badRequest(message = 'Bad Request')
      render json: {
        status: 'NG',
        message: message
      }, status: 500
    end
  end
end
