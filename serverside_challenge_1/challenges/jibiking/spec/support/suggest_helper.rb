shared_examples 'Aのエラーメッセージを返す' do
  it 'Aのエラーメッセージを返す' do
    get path

    expect(response).to be_successful
    expect(body).to eq({
      "Error"=>"Aを指定の値にしてください。"
    })
  end
end