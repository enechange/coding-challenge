require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  context 'when routes are matched' do
    it 'should redirect to the correct URL' do
      expect(get: '/api/show_charges').to route_to(
        controller: 'api',
        action: 'show_charges'
      )
    end
  end

  context 'when routes are unmatched' do
    it 'should redirect to the error URL' do
      expect(get: '/test_route').to route_to(
        controller: 'application',
        action: 'not_found',
        path: 'test_route'
      )
    end
  end
end
