shared_examples 'Aが指定外だった場合のエラーメッセージを返す' do
  it 'Aが指定外だった場合のエラーメッセージを返す' do
    get path

    expect(response.status).to eq(400)
    expect(body).to eq({
      "Error"=>{
          "A"=>[
              "Aには[10, 15, 20, 30, 40, 50, 60]のいずれかの値を入力してください"
          ]
      }
  })
  end
end

shared_examples 'Aが未入力だった場合のエラーメッセージを返す' do
  it 'Aが未入力だった場合のエラーメッセージを返す' do
    get path

    expect(response.status).to eq(400)
    expect(body).to eq({
      "Error"=>{
          "A"=>[
              "Aが未入力です。",
              "Aには[10, 15, 20, 30, 40, 50, 60]のいずれかの値を入力してください"
          ]
      }
  })
  end
end

shared_examples 'kWhが指定外だった場合のエラーメッセージを返す' do
  it 'kWhが指定外だった場合のエラーメッセージを返す' do
    get path

    expect(response.status).to eq(400)
    expect(body).to eq({
      "Error"=>{
          "kWh"=>[
              "kWhには0以上の整数を入力してください"
          ]
      }
  })
  end
end

shared_examples 'kWhが未入力だった場合のエラーメッセージを返す' do
  it 'kWhが未入力だった場合のエラーメッセージを返す' do
    get path

    expect(response.status).to eq(400)
    expect(body).to eq({
      "Error"=>{
          "kWh"=>[
              "kWhが未入力です。",
              "kWhには0以上の整数を入力してください"
          ]
      }
  })
  end
end