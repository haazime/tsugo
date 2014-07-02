require 'spec_helper'
require 'document_merger'

describe "Merge document" do
  subject do
    DocumentMerger.merge(docs)
  end

  context "given 1 document" do
    let(:docs) do
      [
        { "key" => "elmar", "data" => { "length" => "35", "aperture" => "3.5" } }
      ]
    end

    it { is_expected.to eq(docs) }
  end

  context "given 2 different schema document" do
    context "when documents has same key" do
      let(:docs) do
        [
          { "key" => "elmar", "data" => { "length" => "35", "aperture" => "3.5" } },
          { "key" => "elmar", "data" => { "year" => "1954" } },
        ]
      end

      let(:expected) do
        [
          {
            "key" => "elmar",
            "data" => { "length" => "35", "aperture" => "3.5", "year" => "1954" }
          }
        ]
      end

      it { is_expected.to eq(expected) }
    end

    context "when documents has NOT same key" do
      let(:docs) do
        [
          { "key" => "elmar", "data" => { "length" => "35", "aperture" => "3.5" } },
          { "key" => "summicron", "data" => { "year" => "1963" } },
        ]
      end

      let(:expected) do
        [
          { "key" => "elmar", "data" => { "length" => "35", "aperture" => "3.5" } },
          { "key" => "summicron", "data" => { "year" => "1963" } },
        ]
      end

      it { is_expected.to eq(expected) }
    end
  end

  context "given 3 different schema document" do
    context "when documents has same key" do
      let(:docs) do
        [
          { "key" => "summicron", "data" => { "length" => "50", "aperture" => "2" } },
          { "key" => "elmar", "data" => { "length" => "35", "aperture" => "3.5" } },
          { "key" => "elmar", "data" => { "year" => "1954" } },
        ]
      end

      let(:expected) do
        [
          {
            "key" => "summicron",
            "data" => { "length" => "50", "aperture" => "2" }
          },
          {
            "key" => "elmar",
            "data" => { "length" => "35", "aperture" => "3.5", "year" => "1954" }
          }
        ]
      end

      it { is_expected.to eq(expected) }
    end

    context "when documents has NOT same key" do
      let(:docs) do
        [
          { "key" => "elmar", "data" => { "length" => "35", "aperture" => "3.5" } },
          { "key" => "summicron", "data" => { "year" => "1963" } },
          { "key" => "noctilux", "data" => { "length" => "50", "aperture" => "1.1" } },
        ]
      end

      let(:expected) do
        [
          { "key" => "elmar", "data" => { "length" => "35", "aperture" => "3.5" } },
          { "key" => "summicron", "data" => { "year" => "1963" } },
          { "key" => "noctilux", "data" => { "length" => "50", "aperture" => "1.1" } },
        ]
      end

      it { is_expected.to eq(expected) }
    end
  end
end
