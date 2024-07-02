require 'rails_helper'

RSpec.describe "Billings" do
  include Committee::Rails::Test::Methods

  def committee_options
    @committee_options ||= { schema_path: Rails.root.join("../schema/openapi.yaml").to_s }
  end

  describe "POST :calculate" do
    it "returns http success" do
      post "/billings:calculate",
           headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
           params: { amperage: 10, used_kwh: 310 }.to_json
      expect(response).to have_http_status(:success)
      assert_schema_conform(200)
    end
  end
end
