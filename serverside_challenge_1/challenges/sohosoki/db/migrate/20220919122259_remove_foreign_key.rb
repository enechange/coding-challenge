class RemoveForeignKey < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :plans, :providers
    remove_foreign_key :basic_charges, :plans
    remove_foreign_key :pay_as_you_go_fees, :plans
  end
end
