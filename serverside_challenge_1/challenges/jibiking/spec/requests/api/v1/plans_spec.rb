require 'rails_helper'
require 'support/import_helper'

RSpec.describe 'Plans', type: :request do
	describe 'POST /api/v1/plans' do
    let(:path){'/api/v1/plans'}
    let(:success_file){'plans.csv'}
    let(:error_file){'providers.csv'}
    let(:body){ JSON.parse(response.body) }

    describe '成功' do
      it_behaves_like '正しい形式のファイルのインポートに成功すること'
    end

    describe '失敗' do
      it_behaves_like '誤った形式のファイルのインポートに失敗すること'
      it_behaves_like 'ファイルを指定しなかった場合にインポートに失敗すること'
    end
  end
end
