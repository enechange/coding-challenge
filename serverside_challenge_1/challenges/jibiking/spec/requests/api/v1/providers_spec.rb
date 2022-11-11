require 'rails_helper'

RSpec.describe "Providers", type: :request do
  describe "POST /api/v1/providers" do
    describe "成功" do
      context "正しい形式のファイルをインポートした場合" do
        let(:file){'providers.csv'}

        it "インポートに成功する" do
          post '/api/v1/providers', params: {
            file: fixture_file_upload(file, 'providers/csv')
          }

          expect(response).to be_successful
          expect(response.body).to eq("{\"Success\":\"インポートが成功しました。\"}")
        end
      end
    end

    describe "失敗" do
      context "誤った形式のファイルをインポートした場合" do
        let(:error_file){'plans.csv'}

        it "インポートに失敗する" do
          post '/api/v1/providers', params: {
            file: fixture_file_upload(error_file, 'plans/csv')
          }

          expect(response).to be_successful
          expect(response.body).to eq("{\"Erorr\":\"インポートが失敗しました。CSVファイルのデータ形式を見直してください。\"}")
        end
      end
    end
  end
end
