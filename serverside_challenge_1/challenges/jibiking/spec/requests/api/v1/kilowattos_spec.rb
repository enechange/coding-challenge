require 'rails_helper'
require 'support/import_helper'

RSpec.describe 'Kilowattos', type: :request do
	describe 'POST /api/v1/kilowattos' do
    let(:path){'/api/v1/kilowattos'}
    let(:success_file){'kilowattos.csv'}
    let(:error_file){'amperages.csv'}
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
