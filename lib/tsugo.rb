module Tsugo
  class << self

    def merge(collection, key: "key")
      return collection if collection.size == 1
      merge_key = key

      merged = []
      collection.group_by {|d| d[merge_key] }.each do |key, origin|
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

      return merged
    end
  end
end
