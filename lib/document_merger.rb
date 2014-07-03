class DocumentMerger

  def self.merge(documents, *options)
    new(documents, *options).merge
  end

  def initialize(documents, merge_key: "key", data_key: "data")
    @documents = documents
    @merge_key = merge_key
    @data_key = data_key
  end

  def merge
    return @documents if @documents.size == 1

    create_pair_by_key.inject([]) do |result, pair|
      result << pair.merge(@merge_key, @data_key)
    end
  end

private

  def create_pair_by_key
    pairs = @documents.group_by {|d| d[@merge_key] }
    pairs.keys.map {|k| Pair.create(k, pairs[k], @data_key) }
  end

  class Pair

    def self.create(id, raw_data, data_key)
      new(id, raw_data.map {|e| e[data_key] })
    end

    def initialize(id, data)
      @id, @data = id, data
    end

    def merge(id_key, data_key)
      if @data.size <= 2
        {
          id_key => @id,
          data_key => merge_data
        }
      end
    end

    def merge_data
      @data.inject({}) {|r, e| r.merge(e) }
    end
  end
end
