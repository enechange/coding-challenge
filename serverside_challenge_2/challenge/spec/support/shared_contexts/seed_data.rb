# frozen_string_literal: true

RSpec.shared_context 'with seed data' do
  before { Rails.application.load_seed }
end
