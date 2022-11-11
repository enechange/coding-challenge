shared_examples 'Aのエラーメッセージを返す' do
  it 'Aのエラーメッセージを返す' do
    get path

    expect(response).to be_successful
    expect(body).to eq({
      "Error"=>"Aを指定の値にしてください。"
    })
  end
end

shared_examples 'kWhのエラーメッセージを返す' do
  it 'kWhのエラーメッセージを返す' do
    get path

    expect(response).to be_successful
    expect(body).to eq({
      "Error"=>"kWhを指定の値にしてください。"
    })
  end
end