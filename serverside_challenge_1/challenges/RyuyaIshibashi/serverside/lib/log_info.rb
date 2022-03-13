class LogInfo

  # ログレベル: Information
  PROCESS_START = {
    code: '01001',
    message: '処理を開始します。'
  }

  PROCESS_SEARCH = {
    code: '01002',
    message: 'データ取得件数=%{1}件'
  }

  PROCESS_END = {
    code: '01003',
    message: '処理を終了します。'
  }


  # ログレベル: Warn
  INPUT_CHECK = {
    code: '02001',
    message: '不正なリクエストです。項目=%{1}'
  }


  # ログレベル: Error
  EXCEPTION = {
    code: '03001',
    message: '想定外のエラーが発生しました。'
  }

  EXCEPTION_MESSAGE = {
    code: '03002',
    message: 'エラーメッセージ="%{1}"'
  }


  EXCEPTION_TRACE = {
    code: '03003',
    message: 'スタックトレース="%{1}"'
  }

  class << self
    def text (msg_id, args = [])
      "code=#{code(msg_id)}; message='#{message(msg_id, args)}'"
    end
  
    def hash (msg_id, args = [])
      {
        code: code(msg_id),
        message: message(msg_id, args)
      }
    end

    private
      def code(msg_id)
        self.const_get(msg_id)[:code]
      end
    
      def message(msg_id, args = [])
        message = self.const_get(msg_id)[:message]
        replace_hash = [*1..args.count].map{|n| "%{#{n.to_s}}"}.zip(args.map(&:to_s)).to_h
        message.gsub(/%{\d*}/, replace_hash)
      end
  end
end
