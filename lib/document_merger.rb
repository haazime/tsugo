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
    merge_documents
  end

private

  def merge_documents
    group_by_key.inject([]) do |result, group|
      merged_data = group[:_data].inject({}) {|r, e| r.merge(e[@data_key]) }
      result << { @merge_key => group[:_key], @data_key => merged_data }
    end
  end

  def group_by_key
    group = @documents.group_by {|d| d[@merge_key] }
    group.keys.map {|k| { _key: k, _data: group[k] } }
  end
end
