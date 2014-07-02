class DocumentMerger

  def self.merge(documents)
    new(documents).merge
  end

  def initialize(documents)
    @documents = documents
  end

  def merge
    return @documents if @documents.size == 1
    group = @documents.group_by {|d| d["key"] }

    result = []
    group.each do |k, v|
      new_data = v.inject({}) {|r, e| r.merge(e["data"]) }
      result << { "key" => k, "data" => new_data }
    end
    result
  end
end
