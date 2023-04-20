class Api::V1::SearchController < ApplicationController
  def index
      searcher = Api::V1::Search::Searcher.new(search_params)
      if searcher.invalid?
        render json: {
          message: searcher.errors.full_messages
        }, status: 400
        return
      end
      res = searcher.search
      unless res
        render json: {
          message:  "Search failed"
        }, status: 400
        return
      else
        render json: {
          message: "Successfully searched",
          results: res
        }, status: 200
        return
      end
  end

  private

  def search_params
    ampere = params["ampere"].to_i == 0 && params["ampere"] != "0" ? params["ampere"] : params["ampere"].to_i
    kwh = params["kwh"].to_i == 0 && params["kwh"] != "0" ? params["kwh"] : params["kwh"].to_i
    search_params = {
      ampere: ampere,
      kwh: kwh
    }
    return search_params
  end
end
