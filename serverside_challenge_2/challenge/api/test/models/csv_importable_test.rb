# frozen_string_literal: true

require 'test_helper'

class CsvImportableTest < ActiveSupport::TestCase
  setup do
    @csv_file_path = Rails.root.join('test/fixtures/files/csv/providers.csv')
  end

  test '.import_from_csv! はCSVファイルを読み込んでモデルにインポートする' do
    assert_difference 'Provider.count', 3 do
      Provider.import_from_csv!(@csv_file_path)
    end

    providers = Provider.all
    assert { providers.find { |provider| provider.code == 'tokyo-gas' }.name == '東京ガス' }
    assert { providers.find { |provider| provider.code == 'looop-denki' }.name == 'Looopでんき' }
    assert { providers.find { |provider| provider.code == 'tepco' }.name == '東京電力エナジーパートナー' }
  end

  test '.import_from_csv! は同じCSVを複数回インポートしても重複しない' do
    assert_difference 'Provider.count', 3 do
      Provider.import_from_csv!(@csv_file_path)
    end
    assert_no_difference 'Provider.count' do
      Provider.import_from_csv!(@csv_file_path)
    end
  end

  test '.import_from_csv! は既存のレコードを更新する' do
    target_provider = create(:provider, code: 'tokyo-gas', name: 'hoge')

    Provider.import_from_csv!(@csv_file_path)
    assert { target_provider.reload.name == '東京ガス' }
  end

  test '.import_from_csv! はヘッダーのみのCSVの場合何もしない' do
    assert_no_difference 'Provider.count' do
      Provider.import_from_csv!(Rails.root.join('test/fixtures/files/csv/providers_header_only.csv'))
    end
  end

  test '.import_from_csv! はCSVファイルが空の場合例外を発生させる' do
    assert_raises ArgumentError do
      Provider.import_from_csv!(nil)
    end
  end

  test '.import_from_csv! はCSVファイルが存在しない場合例外を発生させる' do
    assert_raises CsvImportable::FileNotFoundError do
      Provider.import_from_csv!(Rails.root.join('test/fixtures/files/csv/providers_not_found.csv'))
    end
  end

  test '.import_from_csv! はcsv_attributesが未実装の場合例外を発生させる' do
    klass = Class.new(ApplicationRecord) do
      include CsvImportable

      class << self
        private

        def csv_upsert_unique_key
          'code'
        end
      end
    end

    assert_raises NotImplementedError do
      klass.import_from_csv!(@csv_file_path)
    end
  end

  test '.import_from_csv! はcsv_upsert_unique_keyが未実装の場合例外を発生させる' do
    klass = Class.new(ApplicationRecord) do
      include CsvImportable

      class << self
        private

        def csv_attributes
          %w[code name]
        end
      end
    end

    assert_raises NotImplementedError do
      klass.import_from_csv!(@csv_file_path)
    end
  end

  test '.import_from_csv! はユニークキーが空の場合例外を発生させる' do
    assert_raises CsvImportable::UniqueKeyMissingError do
      Provider.import_from_csv!(Rails.root.join('test/fixtures/files/csv/providers_unique_key_empty.csv'))
    end
  end

  test '.import_from_csv! はバリデーションエラーが発生した場合例外を発生させる' do
    assert_raises ActiveRecord::RecordInvalid do
      Provider.import_from_csv!(Rails.root.join('test/fixtures/files/csv/providers_invalid.csv'))
    end
  end

  test '.import_from_csv! は途中でエラーが発生した場合ロールバックする' do
    assert_raises ActiveRecord::RecordInvalid do
      Provider.import_from_csv!(Rails.root.join('test/fixtures/files/csv/providers_invalid.csv'))
    end
    assert { Provider.count == 0 }
  end

  test '.import_from_csv! はcodeからidへ変換してモデルにインポートする' do
    Provider.import_from_csv!(@csv_file_path)
    plan_csv_file_path = Rails.root.join('test/fixtures/files/csv/plans.csv')

    assert_difference 'Plan.count', 4 do
      Plan.import_from_csv!(plan_csv_file_path)
    end

    plan = Plan.find_by(code: 'juuryouB')
    provider = Provider.find_by(code: 'tepco')
    assert { plan.provider_id == provider.id }
  end

  test '.import_from_csv! はcodeが存在しない場合例外を発生させる' do
    assert_raises CsvImportable::UniqueKeyMissingError do
      Plan.import_from_csv!(Rails.root.join('test/fixtures/files/csv/plans_invalid_provider.csv'))
    end
  end
end
