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

    group_by_key.inject([]) do |result, group|
      result << group.to_hash(@merge_key, @data_key)
    end
  end

private

  def group_by_key
    group = @documents.group_by {|d| d[@merge_key] }
    group.keys.map {|k| Group.create(k, group[k], @data_key) }
  end

  class Group

    def self.create(id, raw_data, data_key)
      new(id, raw_data.map {|e| e[data_key] })
    end

    def initialize(id, data)
      @id, @data = id, data
    end

    def merge_data
      @data.inject({}) {|r, e| r.merge(e) }
    end

    def to_hash(id_key, data_key)
      {
        id_key => @id,
        data_key => merge_data
      }
    end
  end
end
