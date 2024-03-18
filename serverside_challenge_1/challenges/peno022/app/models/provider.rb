# frozen_string_literal: true

class Provider
  attr_reader :name

  def initialize(name)
    @name = name
  end
end
