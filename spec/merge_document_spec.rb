require 'spec_helper'
require 'document_merger'

describe "Documentのマージ" do
  subject do
    DocumentMerger.merge(docs)
  end

  context "Documentが1つの場合" do
    let(:docs) do
      [
        { "key" => "elmar", "data" => { "length" => "35", "aperture" => "3.5" } }
      ]
    end

    it("そのまま") { is_expected.to eq(docs) }
  end

  context "2種類のDocumentが1件ずつある" do
    context "結合キーが同じ" do
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

      it("結合する") { is_expected.to eq(expected) }
    end

    context "結合キーが違う" do
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

      it("結合しない") { is_expected.to eq(expected) }
    end
  end

  context "2種類のDocumentが3件以上ある" do
    context "結合キーが同じDocumentが2件ある" do
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

      it("結合する") { is_expected.to eq(expected) }
    end

    context "結合キーが同じDocumentが3件ある" do
      pending do
      let(:docs) do
        [
          { "key" => "summicron", "data" => { "length" => "50", "aperture" => "2" } },
          { "key" => "summicron", "data" => { "length" => "35", "aperture" => "2" } },
          { "key" => "summicron", "data" => { "year" => "1963" } },
        ]
      end

      let(:expected) do
        [
          {
            "key" => "summicron",
            "data" => { "length" => "35", "aperture" => "2", "year" => "1963" }
          },
          {
            "key" => "summicron",
            "data" => { "length" => "50", "aperture" => "2", "year" => "1963" }
          }
        ]
      end

      it("件数が多い種類に合わせて結合する") { is_expected.to eq(expected) }
      end
    end

    context "結合キーが全て違う" do
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

      it("結合しない") { is_expected.to eq(expected) }
    end
  end
end
