# frozen_string_literal: true

require "webmock/rspec"
require "httpx/adapters/webmock"

describe TwelvedataRuby::Request do
  it "DEFAULT_HTTP_VERB class constant is equal to `:get`" do
    expect(described_class::DEFAULT_HTTP_VERB).to eql(:get)
  end

  describe "instance" do
    let(:endpoint_options) { [:quote, {symbol: "IBM"}] }
    let(:fetched_response) { subject.fetch }
    subject { described_class.new(endpoint_options[0], **endpoint_options[1])}
    context "valid" do
      let(:endpoint) { subject.endpoint }

      it "expected to be valid" do
        is_expected.to be_valid
      end

      it "#params to be based from #endpoint.query_params" do
        expect(subject.params).to eq({params: endpoint.query_params})
      end

      it "#http_verb to equal to `:get`" do
        expect(subject.http_verb).to eq(:get)
      end

      it "#relative_url to eqaul to #endpoint.name" do
        expect(subject.relative_url).to eq(endpoint.name.to_s)
      end

      it "#to_a is a array instance" do
        expect(subject.to_a).to eq([subject.http_verb, subject.relative_url, subject.params])
      end

      it "#to_h values is equal to #to_a" do
        expect(subject.to_h.values).to eq(subject.to_a)
      end

      it "#build is #to_a alias" do
        expect(subject.method(:build)).to eq(subject.method(:to_a))
      end

      it "#fetch to be an an instance of TwelvedataRuby::Response"

    end

    context "invalid" do
      let(:endpoint_options) { [:quote, {}] }
      it "expected to be NOT valid" do
        is_expected.to_not be_valid
      end

      it "#fetch to have errors" do
        expect(fetched_response).to have_key(:errors)
      end
    end
  end
end
