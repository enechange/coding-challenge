class Company < ApplicationRecord
  has_many :plans
  
  validates :id, presence: true, uniqueness: true
  validates :name, presence: true

  class << self
    def csv_header_converters
      headers = {
        'ID' => :id,
        'NAME' => :name
      }
      lambda { |name| headers[name] }
    end
  end
end
