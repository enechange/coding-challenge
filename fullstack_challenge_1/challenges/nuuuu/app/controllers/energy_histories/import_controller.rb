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

      begin
        imported_lines = EnergyHistories::ImportService.new.run(uploaded_file)
      rescue EnergyHistories::ImportService::ImportError => e
        flash[:alert] = "インポートできませんでした。[#{e.message}]"
        return redirect_to action: 'index'
      end


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
