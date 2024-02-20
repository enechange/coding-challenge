require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  describe 'Logic tests' do
    context 'routes' do
      it 'should redirect to the correct URL' do
        expect(get: '/api/show_charges').to route_to(
          controller: 'api',
          action: 'show_charges'
        )
      end

      it 'should redirect to the error URL for unmatched routes' do
        expect(get: '/test_route').to route_to(
          controller: 'application',
          action: 'not_found',
          path: 'test_route'
        )
      end
    end
  end
end
