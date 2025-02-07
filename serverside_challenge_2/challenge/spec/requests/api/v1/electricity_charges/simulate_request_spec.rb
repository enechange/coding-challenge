# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::ElectricityCharges::SimulateController, type: :request  do
  describe "GET /api/v1/electricity_charges/simulate" do
    context "when the request is valid" do
      before do
        get "/api/v1/electricity_charges/simulate", params: simulate_params
      end

      context "when status is success" do
        let(:simulate_params) { { ampere: 30, usage: 100 } }

        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end

        it "conforms to response schema with 200 response code" do
          assert_schema_conform(200)
        end
      end
    end

    context "when the request is invalid" do
      context "when status code 400 " do
        before do
          get "/api/v1/electricity_charges/simulate", params: simulate_params
        end

        context "when ampere is missing" do
          let(:simulate_params) { { usage: 10 } }

          it "returns status code 400" do
            expect(response).to have_http_status(400)
          end

          it "returns a validation failure message" do
            expect(response.parsed_body["error"])
            .to match(/Ampere can't be blank/)
          end

          it "conforms to response schema with 400 response code" do
            assert_response_schema_confirm(400)
          end
        end

        context "when ampere is not in the allowed list of parameters" do
          let(:simulate_params) { { ampere: 70 } }

          it "returns status code 400" do
            expect(response).to have_http_status(400)
          end

          it "returns a validation failure message" do
            expect(response.parsed_body["error"])
            .to match(/Ampere is not included in the list/)
          end

          it "conforms to response schema with 400 response code" do
            assert_response_schema_confirm(400)
          end
        end

        context "when usage is missing" do
          let(:simulate_params) { { ampere: 10 } }

          it "returns status code 400" do
            expect(response).to have_http_status(400)
          end

          it "returns a validation failure message" do
            expect(response.parsed_body["error"])
            .to match(/Usage can't be blank/)
          end

          it "conforms to response schema with 400 response code" do
            assert_response_schema_confirm(400)
          end
        end

        context "when usage is not a number" do
          let(:simulate_params) { { usage: "hoge" } }

          it "returns status code 400" do
            expect(response).to have_http_status(400)
          end

          it "returns a validation failure message" do
            expect(response.parsed_body["error"])
            .to match(/Usage is not a number/)
          end

          it "conforms to response schema with 400 response code" do
            assert_response_schema_confirm(400)
          end
        end
      end

      context "when the server returns an Internal Server Error" do
        let(:simulate_params) { { ampere: 10, usage: 0 } }
        let!(:service) { instance_double(FetchElectricityChargeService) }

        before do
          allow(FetchElectricityChargeService).to receive(:new).and_return(service)
          allow(service).to receive(:call).and_raise(StandardError)

          get "/api/v1/electricity_charges/simulate", params: simulate_params
        end

        it "returns status code 500" do
          expect(response).to have_http_status(500)
        end

        it "conforms to response schema with 500 response code" do
          assert_response_schema_confirm(500)
        end
      end
    end
  end
end
