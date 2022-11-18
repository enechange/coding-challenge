shared_examples '正しい形式のファイルを指定した場合' do
	it 'インポートに成功する' do
		post path, params: {
			file: fixture_file_upload(success_file)
		}

		expect(response.status).to eq(200)
		expect(body).to eq({
			"Success"=>"インポートが成功しました。"
	})
	end
end

shared_examples '誤った形式のファイルを指定した場合' do
	it 'インポートに失敗する' do
		post path, params: {
			file: fixture_file_upload(error_file)
		}

		expect(response.status).to eq(400)
		expect(body).to eq({
			"Erorr"=>"インポートが失敗しました。CSVファイルのデータ形式を見直してください。"
	})
	end
end

shared_examples 'ファイルを指定しなかった場合' do
	it 'インポートに失敗する' do
		post path, params: {
			file: ''
		}

		expect(response.status).to eq(400)
		expect(body).to eq({
			"Erorr"=>"インポートが失敗しました。CSVファイルを指定してください。"
		})
	end
end