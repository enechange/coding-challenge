require 'factory_bot'

RSpec.configure do |config|
  # FactoryBotのデータ呼び出しを簡略化できる
  config.include FactoryBot::Syntax::Methods
end
