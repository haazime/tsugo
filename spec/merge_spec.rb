require 'spec_helper'

describe "HashのArrayのマージ" do
  subject do
    Tsugo::Collection.merge(collection, key: "name")
  end

  context "Hashが1つの場合" do
    let(:collection) do
      [
        { "name" => "elmar", "length" => "35", "aperture" => "3.5" }
      ]
    end

    it("そのまま") { is_expected.to match_array(collection) }
  end

  context "Hashが2種類の場合" do
    context "HashA,HashBが1件ずつ" do
      context "結合キーの値が同じ" do
        let(:collection) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "elmar", "year" => "1954" },
          ]
        end

        let(:expected) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5", "year" => "1954" }
          ]
        end

        it("結合する") { is_expected.to match_array(expected) }
      end

      context "結合キーの値が違う" do
        let(:collection) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "summicron", "year" => "1963" },
          ]
        end

        let(:expected) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "summicron", "year" => "1963" },
          ]
        end

        it("結合しない") { is_expected.to match_array(expected) }
      end
    end

    context "HashAが2件,HashBが1件の場合" do
      context "HashAとHashBで結合キーが同じ値の組が1つ" do
        let(:collection) do
          [
            { "name" => "summicron", "length" => "50", "aperture" => "2" },
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "elmar", "year" => "1954" },
          ]
        end

        let(:expected) do
          [
            { "name" => "summicron", "length" => "50", "aperture" => "2" },
            { "name" => "elmar", "length" => "35", "aperture" => "3.5", "year" => "1954" }
          ]
        end

        it("1組結合する") { is_expected.to match_array(expected) }
      end

      context "全て結合キーの値が同じ" do
        let(:collection) do
          [
            { "name" => "summicron", "length" => "50", "aperture" => "2" },
            { "name" => "summicron", "length" => "35", "aperture" => "2" },
            { "name" => "summicron", "year" => "1963" },
          ]
        end

        let(:expected) do
          [
            { "name" => "summicron", "length" => "35", "aperture" => "2", "year" => "1963" },
            { "name" => "summicron", "length" => "50", "aperture" => "2", "year" => "1963" }
          ]
        end

        it("HashBを2件に増やして結合する") { is_expected.to match_array(expected) }
      end

      context "結合キーの値が全て違う" do
        let(:collection) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "summicron", "year" => "1963" },
            { "name" => "noctilux", "length" => "50", "aperture" => "1.1" },
          ]
        end

        let(:expected) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "summicron", "year" => "1963" },
            { "name" => "noctilux", "length" => "50", "aperture" => "1.1" },
          ]
        end

        it("結合しない") { is_expected.to match_array(expected) }
      end
    end
  end

  context "Hashが3種類の場合" do
    context "HashA,HashB,HashCが1件ずつ" do
      context "結合キーの値が同じ" do
        let(:collection) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "elmar", "year" => "1954" },
            { "name" => "elmar", "new_price" => "500", "old_price" => "300" },
          ]
        end

        let(:expected) do
          [
            {
              "name" => "elmar",
              "length" => "35", "aperture" => "3.5",
              "year" => "1954",
              "new_price" => "500", "old_price" => "300"
            }
          ]
        end

        it("結合する") { is_expected.to match_array(expected) }
      end

      context "HashAとHashBの結合キーの値が同じ" do
        let(:collection) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "elmar", "year" => "1954" },
            { "name" => "elmarit", "new_price" => "1100", "old_price" => "900" },
          ]
        end

        let(:expected) do
          [
            {
              "name" => "elmar",
              "length" => "35", "aperture" => "3.5",
              "year" => "1954"
            },
            {
              "name" => "elmarit",
              "new_price" => "1100", "old_price" => "900"
            }
          ]
        end

        it("1組結合する") { is_expected.to match_array(expected) }
      end

      context "結合キーの値が違う" do
        let(:collection) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "summicron", "year" => "1963" },
            { "name" => "summaron", "new_price" => "700", "old_price" => "550" },
          ]
        end

        let(:expected) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "summicron", "year" => "1963" },
            { "name" => "summaron", "new_price" => "700", "old_price" => "550" },
          ]
        end

        it("結合しない") { is_expected.to match_array(expected) }
      end
    end

    context "HashAが2件,HashBが1件,HashCが2件の場合" do
      context "HashAとHashBとHashCで結合キーが同じ値の組が1つ" do
        let(:collection) do
          [
            { "name" => "summicron", "length" => "50", "aperture" => "2" },
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "elmar", "year" => "1954" },
            { "name" => "elmar", "new_price" => "700", "old_price" => "500" },
            { "name" => "summilux", "new_price" => "1800", "old_price" => "1100" },
          ]
        end

        let(:expected) do
          [
            { "name" => "summicron", "length" => "50", "aperture" => "2" },
            {
              "name" => "elmar",
              "length" => "35", "aperture" => "3.5",
              "year" => "1954",
              "new_price" => "700", "old_price" => "500"
            },
            { "name" => "summilux", "new_price" => "1800", "old_price" => "1100" }
          ]
        end

        it("1組結合する") { is_expected.to match_array(expected) }
      end

      context "HashAとHashBとHashCで結合キーが同じ値の組が2つ" do
        let(:collection) do
          [
            { "name" => "summicron", "length" => "50", "aperture" => "2" },
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "elmar", "year" => "1954" },
            { "name" => "elmar", "new_price" => "700", "old_price" => "500" },
            { "name" => "summicron", "new_price" => "1800", "old_price" => "1100" },
          ]
        end

        let(:expected) do
          [
            {
              "name" => "summicron",
              "length" => "50", "aperture" => "2",
              "new_price" => "1800", "old_price" => "1100"
            },
            {
              "name" => "elmar",
              "length" => "35", "aperture" => "3.5",
              "year" => "1954",
              "new_price" => "700", "old_price" => "500"
            },
          ]
        end

        it("2組結合する") { is_expected.to match_array(expected) }
      end

      context "全て結合キーの値が同じ" do
        let(:collection) do
          [
            { "name" => "summicron", "length" => "50", "aperture" => "2" },
            { "name" => "summicron", "length" => "35", "aperture" => "2" },
            { "name" => "summicron", "year" => "1963" },
            { "name" => "summicron", "new_price" => "1000", "old_price" => "800" },
            { "name" => "summicron", "new_price" => "2300", "old_price" => "1500" },
          ]
        end

        let(:expected) do
          [
            {
              "name" => "summicron",
              "length" => "50", "aperture" => "2",
              "year" => "1963",
              "new_price" => "1000", "old_price" => "800"
            },
            {
              "name" => "summicron",
              "length" => "35", "aperture" => "2",
              "year" => "1963",
              "new_price" => "2300", "old_price" => "1500"
            }
          ]
        end

        it("HashBを2件に増やして2組結合する") { is_expected.to match_array(expected) }
      end

      context "結合キーの値が全て違う" do
        let(:collection) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "summicron", "year" => "1963" },
            { "name" => "noctilux", "length" => "50", "aperture" => "1.1" },
            { "name" => "super-angulon", "new_price" => "1300", "old_price" => "1100" },
            { "name" => "hektor", "new_price" => "1400", "old_price" => "900" },
          ]
        end

        let(:expected) do
          [
            { "name" => "elmar", "length" => "35", "aperture" => "3.5" },
            { "name" => "summicron", "year" => "1963" },
            { "name" => "noctilux", "length" => "50", "aperture" => "1.1" },
            { "name" => "super-angulon", "new_price" => "1300", "old_price" => "1100" },
            { "name" => "hektor", "new_price" => "1400", "old_price" => "900" },
          ]
        end

        it("結合しない") { is_expected.to match_array(expected) }
      end
    end
  end
end
