require 'rails_helper'
require 'support/import_helper'

RSpec.describe 'Amperages', type: :request do
	describe 'POST /api/v1/amperages' do
    let(:path){'/api/v1/amperages'}
    let(:success_file){'amperages.csv'}
    let(:error_file){'kilowattos.csv'}
    let(:body){ JSON.parse(response.body) }

    describe '成功' do
      it_behaves_like '正しい形式のファイルのインポートに成功すること'
    end

    describe '失敗' do
      it_behaves_like '誤った形式のファイルのインポートに失敗すること'
    end
  end
end
