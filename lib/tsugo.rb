module Tsugo
  class Collection

    class << self

      def merge(documents, *options)
        new(documents, *options).merge
      end
    end

    def initialize(documents, key: "key")
      @documents = documents
      @merge_key = key
    end

    def merge
      return @documents if @documents.size == 1

      merged = []
      @documents.group_by {|d| d[@merge_key] }.each do |key, origin|
        padded = []

        schema_sets = origin.group_by {|o| o.keys.hash }

        max_size_of_sets = schema_sets.values.map {|v| v.size }.max

        schema_sets.values.each do |schema_set|
          until schema_set.size == max_size_of_sets
            schema_set << schema_set.first
          end
          padded << schema_set
        end

        padded.inject(&:zip).each do |same_key_docs|
          merged_doc = [same_key_docs].flatten.inject(&:merge)
          merged << merged_doc
        end
      end

      merged
    end
  end
end
