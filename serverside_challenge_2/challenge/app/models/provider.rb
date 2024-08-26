# frozen_string_literal: true

# == Schema Information
#
# Table name: providers
#
#  id           :bigint           not null, primary key
#  name(会社名) :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Provider < ApplicationRecord
end
