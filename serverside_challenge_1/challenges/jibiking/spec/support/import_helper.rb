shared_examples '正しい形式のファイルのインポートに成功すること' do
	it 'インポートに成功する' do
		post path, params: {
			file: fixture_file_upload(success_file)
		}

		expect(response).to be_successful
		expect(body).to eq({
			"Success"=>"インポートが成功しました。"
	})
	end
end

shared_examples '誤った形式のファイルのインポートに失敗すること' do
	it 'インポートに失敗する' do
		post path, params: {
			file: fixture_file_upload(error_file)
		}

		expect(response).to be_successful
		expect(body).to eq({
			"Erorr"=>"インポートが失敗しました。CSVファイルのデータ形式を見直してください。"
	})
	end
end