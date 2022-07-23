require "test_helper"

class ProviderTest < ActiveSupport::TestCase

  test "登録データ件数が4件であること" do
    assert_equal Provider.count, 4
  end

  test "PKで取得した『東京電力エナジーパートナー』の電力会社名が正しいこと" do
    provider = Provider.find(1)
    assert_equal provider.provider_name, "東京電力エナジーパートナー"
  end

  test "PKで取得した『東京電力エナジーパートナー』のプラン名が正しいこと" do
    provider = Provider.find(1)
    assert_equal provider.plan_name, "従量電灯B"
  end
  
  test "PKで取得した『Looopでんき』の電力会社名が正しいこと" do
    provider = Provider.find(2)
    assert_equal provider.provider_name, "Looopでんき"
  end

  test "PKで取得した『Loopでんき』のプラン名が正しいこと" do
    provider = Provider.find(2)
    assert_equal provider.plan_name, "おうちプラン"
  end
  
  test "PKで取得した『東京ガス』の電力会社名が正しいこと" do
    provider = Provider.find(3)
    assert_equal provider.provider_name, "東京ガス"
  end

  test "PKで取得した『東京ガス』のプラン名が正しいこと" do
    provider = Provider.find(3)
    assert_equal provider.plan_name, "ずっとも電気1"
  end

  test "PKで取得した『JXTGでんき』の電力会社名が正しいこと" do
    provider = Provider.find(4)
    assert_equal provider.provider_name, "JXTGでんき"
  end

  test "PKで取得した『JXTGでんき』のプラン名が正しいこと" do
    provider = Provider.find(4)
    assert_equal provider.plan_name, "従量電灯Bたっぷりプラン"
  end
end
