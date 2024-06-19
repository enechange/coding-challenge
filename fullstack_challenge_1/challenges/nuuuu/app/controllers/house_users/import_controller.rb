module HouseUsers
  class ImportController < ApplicationController
    def index

    end

    def create
      uploaded_file = create_params[:file]
      if uploaded_file.nil?
        flash[:alert] = "ファイルが参照されていません"
        return redirect_to action: 'index'
      end

      begin
        imported_lines = HouseUsers::ImportService.new.run(uploaded_file)
      rescue HouseUsers::ImportService::ImportError => e
        flash[:alert] = "インポートできませんでした。[#{e.message}]"
        return redirect_to action: 'index'
      end

      flash[:result] = "#{imported_lines}行のデータをインポートしました。"
      redirect_to action: 'index'
    end

    private

    def create_params
      params.require(:house_user_file).permit(:file)
    rescue ActionController::ParameterMissing
      {}
    end
  end
end
