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
    group = @documents.group_by {|d| d[@merge_key] }

    group.keys.inject([]) do |result, k|
      merged_data = group[k].inject({}) {|r, e| r.merge(e[@data_key]) }
      result << { @merge_key => k, @data_key => merged_data }
    end
  end
end
