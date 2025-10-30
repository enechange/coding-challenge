# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # https://github.com/rails/rails/blob/b180e2c522c372f5d028d6a5113e69ff416128ab/activemodel/lib/active_model/type/integer.rb#L100
  INTEGER_MAX = ActiveRecord::Type::Integer.new.__send__(:max_value)
end
