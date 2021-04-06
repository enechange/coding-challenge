module EnergyHistories
  class ImportController < ApplicationController
    def index

    end

    def create
      uploaded_file = create_params[:file]
      imported_lines = EnergyHistories::ImportService.new.run(uploaded_file)

      flash[:result] = "#{imported_lines}行のデータをインポートしました。"
      redirect_to action: 'index'
    end

    private

    def create_params
      params.require(:energy_history_file).permit(:file)
    end
  end
end
