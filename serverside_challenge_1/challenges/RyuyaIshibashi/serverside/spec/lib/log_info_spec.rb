require "spec_helper"
require "log_info"


describe LogInfo do
  it "初期処理のログテキストが正しく返却されること" do
    expect(LogInfo.getText('PROCESS_START')).to eq "code=01001; message='処理を開始します。'"
  end

  it "検索処理のテキストが正しく返却されること" do
    expect(LogInfo.getText('PROCESS_SEARCH', [3])).to eq "code=01002; message='データ取得件数＝3件'"
  end

  it "終了処理のログテキストが正しく返却されること" do
    expect(LogInfo.getText('PROCESS_END')).to eq "code=01003; message='処理を終了します。'"
  end

  context "入力チェックの" do
    it "テキストが正しく返却されること" do
      expect(LogInfo.getText('INPUT_CHECK', ['アンペア'])).to eq "code=02001; message='不正なリクエストです。項目=アンペア'"
    end

    it "ハッシュが正しく返却されること" do
      expect(LogInfo.getHash('INPUT_CHECK', ['アンペア'])).to eq ({ code: '02001', message: "不正なリクエストです。項目=アンペア" })
    end
  end

  context "Exception発生時の" do
    it "テキストが正しく返却されること" do
      expect(LogInfo.getText('EXCEPTION')).to eq "code=03001; message='想定外のエラーが発生しました。'"
    end

    it "ハッシュが正しく返却されること" do
      expect(LogInfo.getHash('EXCEPTION')).to eq ({ code: '03001', message: "想定外のエラーが発生しました。" })
    end
  end

  it "Exceptionメッセージのログテキストが正しく返却されること" do
    expect(LogInfo.getText('EXCEPTION_MESSAGE', ['hogehoge'])).to eq "code=03002; message='エラーメッセージ=\"hogehoge\"'"
  end

  it "Exceptionスタックトレースのログテキストが正しく返却されること" do
    expect(LogInfo.getText('EXCEPTION_TRACE', ['hogehoge'])).to eq "code=03003; message='スタックトレース=\"hogehoge\"'"
  end
end
