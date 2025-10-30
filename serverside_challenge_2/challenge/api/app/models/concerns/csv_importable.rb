# frozen_string_literal: true

require 'csv'
module CsvImportable
  class FileNotFoundError < StandardError; end
  class UniqueKeyMissingError < StandardError; end

  ENCODING = 'UTF-8'

  extend ActiveSupport::Concern

  class_methods do
    # NOTE: 現時点ではレコード数が少ないため1件ずつsave!で十分と判断。
    #       大量データに対応する必要が出た場合は upsert_all などでのバルクインサートに置き換える。
    def import_from_csv!(file_path)
      raise ArgumentError if file_path.blank?
      raise FileNotFoundError unless File.exist?(file_path)

      transaction do
        CSV.foreach(file_path, headers: true, encoding: ENCODING).with_index(2) do |row, line_number|
          attrs = row.to_h.slice(*csv_attributes).compact
          converted_attrs = convert_attrs!(attrs)
          unique_keys = csv_upsert_unique_keys
          unique_conditions = unique_keys.index_with { |key| converted_attrs[key] }

          if unique_conditions.values.any?(&:blank?)
            raise UniqueKeyMissingError, "ユニークキー(#{unique_keys.join(", ")})が空です"
          end

          record = find_or_initialize_by(unique_conditions)
          record.assign_attributes(converted_attrs)
          record.save!
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error("[#{name}] 行数#{line_number}: #{e.record.errors.full_messages.join(", ")} (入力内容: #{row.to_h})")
          raise
        rescue UniqueKeyMissingError => e
          Rails.logger.error("[#{name}] 行数#{line_number}: #{e.message} (入力内容: #{row.to_h})")
          raise
        end
      end
    end

    private

    def convert_attrs!(attrs)
      attrs
    end

    def convert_code_to_id(attrs, code_key:, id_key:, target_mappings:)
      code = attrs.delete(code_key)
      target_id = target_mappings[code]

      if target_id.blank?
        raise CsvImportable::UniqueKeyMissingError, "#{code_key}: #{code} が存在しません"
      end

      attrs.merge(id_key => target_id)
    end

    def csv_attributes
      raise NotImplementedError
    end

    def csv_upsert_unique_keys
      raise NotImplementedError
    end
  end
end
