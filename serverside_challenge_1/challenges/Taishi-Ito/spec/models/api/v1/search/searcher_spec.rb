require 'rails_helper'

RSpec.describe Api::V1::Search::Searcher, type: :model do
  describe 'validation' do
    let(:searcher) { Api::V1::Search::Searcher.new(search_params) }
    context "ampere is 50 and kwh is 120 " do
      let(:search_params) { { ampere: 50, kwh: 120} }
      it "should be valid" do
        expect(searcher).to be_valid
      end
    end

    context "ampere is 50 and kwh is 0 " do
      let(:search_params) { { ampere: 50, kwh: 0} }
      it "should be valid" do
        expect(searcher).to be_valid
      end
    end

    context "ampere is 0 " do
      let(:search_params) { { ampere: 0, kwh: 120} }
      it "should be invalid" do
        expect(searcher).to be_invalid
      end
    end

    context "ampere is not exsist" do
      let(:search_params) { { ampere: 80, kwh: 120} }
      it "should be invalid" do
        expect(searcher).to be_invalid
      end
    end

    context "ampere is string" do
      let(:search_params) { { ampere: "test", kwh: 120} }
      it "should be invalid" do
        expect(searcher).to be_invalid
      end
    end

    context "kwh is string" do
      let(:search_params) { { ampere: 50, kwh: "test"} }
      it "should be invalid" do
        expect(searcher).to be_invalid
      end
    end

    context "ampere is nil" do
      let(:search_params) { { ampere: nil, kwh: 120} }
      it "should be invalid" do
        expect(searcher).to be_invalid
      end
    end

    context "kwh is nil" do
      let(:search_params) { { ampere: 50, kwh: nil} }
      it "should be invalid" do
        expect(searcher).to be_invalid
      end
    end
  end

  describe 'search method' do
    let(:searcher) { Api::V1::Search::Searcher.new(search_params) }
    context "ampere is 50 and kwh is 120" do
      let(:search_params) { { ampere: 50, kwh: 120} }
      it "response size should be 4" do
        expect(searcher.search.size).to eq 4
      end

      it "provider_name should be present" do
        expect(searcher.search[0][:provider_name]).to be_present
      end

      it "plan_name should be present" do
        expect(searcher.search[0][:plan_name]).to be_present
      end

      it "price should be present" do
        expect(searcher.search[0][:price]).to be_present
      end
    end

    context "ampere is 0 and kwh is 120" do
      let(:search_params) { { ampere: 0, kwh: 120} }
      it "response size should be 0" do
        expect(searcher.search.size).to eq 0
      end
    end

    context "ampere is 50 and kwh is 0" do
      let(:search_params) { { ampere: 50, kwh: 0} }
      it "response size should be 4" do
        expect(searcher.search.size).to eq 4
      end
    end

    context "ampere is nil and kwh is 120" do
      let(:search_params) { { ampere: nil, kwh: 120} }
      it "response should be nil" do
        expect(searcher.search).to eq nil
      end
    end

    context "ampere is 50 and kwh is nil" do
      let(:search_params) { { ampere: 50, kwh: nil} }
      it "response should be nil" do
        expect(searcher.search).to eq nil
      end
    end
  end
end
