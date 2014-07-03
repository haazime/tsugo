require 'hashie'

class Document < Hash
  include Hashie::Extensions::DeepMerge

  alias_method :aggregate, :deep_merge

  class << self

    def parse(hash)
      new.merge(hash)
    end
  end
end

class DocumentMerger

  class << self

    def merge(documents, *options)
      new(documents, *options).merge
    end

    def create_document(hashes)
      hashes.map {|h| Document.parse(h) }
    end
  end

  def initialize(hashes, merge_key: "key", data_key: "data")
    @documents = self.class.create_document(hashes)
    @merge_key = merge_key
    @data_key = data_key
  end

  def merge
    return @documents if @documents.size == 1

    groups = @documents.group_by {|d| d[@merge_key] }
    groups.keys.inject([]) do |result, group_key|
      group = groups[group_key]
      if group.size <= 2
        result << group[0].aggregate(group[1])
      end
    end
  end
end
