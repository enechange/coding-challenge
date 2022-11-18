require 'rails_helper'
require 'support/import_helper'

RSpec.describe 'import', type: :request do
  let(:body){ JSON.parse(response.body) }

  describe 'POST /api/v1/providers' do
    let(:path){'/api/v1/providers'}
    let(:success_file){'providers.csv'}
    let(:error_file){'error_providers.csv'}

    describe '成功' do
      it_behaves_like '正しい形式のファイルを指定した場合'
    end

    describe '失敗' do
      it_behaves_like '誤った形式のファイルを指定した場合'
      it_behaves_like 'ファイルを指定しなかった場合'
    end
  end


	describe 'POST /api/v1/plans' do
    let(:path){'/api/v1/plans'}
    let(:success_file){'plans.csv'}
    let(:error_file){'error_plans.csv'}

    before do
      # テストデータの挿入
      post '/api/v1/providers', params: {file: fixture_file_upload('providers.csv')}
    end

    describe '成功' do
      it_behaves_like '正しい形式のファイルを指定した場合'
    end

    describe '失敗' do
      it_behaves_like '誤った形式のファイルを指定した場合'
      it_behaves_like 'ファイルを指定しなかった場合'
    end
  end


  describe 'POST /api/v1/amperages' do
    let(:path){'/api/v1/amperages'}
    let(:success_file){'amperages.csv'}
    let(:error_file){'error_amperages.csv'}

    before do
      # テストデータの挿入
      post '/api/v1/providers', params: {file: fixture_file_upload('providers.csv')}
      post '/api/v1/plans', params: {file: fixture_file_upload('plans.csv')}
    end

    describe '成功' do
      it_behaves_like '正しい形式のファイルを指定した場合'
    end

    describe '失敗' do
      it_behaves_like '誤った形式のファイルを指定した場合'
      it_behaves_like 'ファイルを指定しなかった場合'
    end
  end

  
  describe 'POST /api/v1/kilowattos' do
    let(:path){'/api/v1/kilowattos'}
    let(:success_file){'kilowattos.csv'}
    let(:error_file){'error_kilowattos.csv'}

    before do
      # テストデータの挿入
      post '/api/v1/providers', params: {file: fixture_file_upload('providers.csv')}
      post '/api/v1/plans', params: {file: fixture_file_upload('plans.csv')}
    end

    describe '成功' do
      it_behaves_like '正しい形式のファイルを指定した場合'
    end

    describe '失敗' do
      it_behaves_like '誤った形式のファイルを指定した場合'
      it_behaves_like 'ファイルを指定しなかった場合'
    end
  end
end
