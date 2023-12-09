# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ルーティングテスト', type: :routing do
  it 'ルーティング to plans#list' do
    expect(get: 'api/v1/plans/all/10/100').to route_to(
      controller: 'api/v1/plans',
      action: 'list',
      ampere: '10',
      usage: '100'
    )
  end

  it '無効なルーティングは route_not_found にリダイレクトされる' do
    expect(get: 'api/v1/plans/undefined/10/100').to route_to(
      controller: 'application',
      action: 'route_not_found',
      path: 'api/v1/plans/undefined/10/100'
    )
  end
end
