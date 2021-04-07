module EnergyHistories
  class ImportController < ApplicationController
    def index
    end

    def create
      uploaded_file = create_params[:file]
      if uploaded_file.nil?
        flash[:alert] = "ファイルが参照されていません"
        return redirect_to action: 'index'
      end

      imported_lines = EnergyHistories::ImportService.new.run(uploaded_file)

      flash[:info] = "#{imported_lines}行のデータをインポートしました。"
      redirect_to action: 'index'
    end

    private

    def create_params
      params.require(:energy_history_file).permit(:file)
    rescue ActionController::ParameterMissing
      {}
    end
  end
end
