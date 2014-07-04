module Tsugo
  class Document < Hash

    def self.from_hash(h)
      new.merge(h)
    end

    def schema
      keys.hash
    end
  end

  class DocumentGroupWithSchema
    include Enumerable

    def initialize(documents=[])
      @documents = documents
    end

    def each
      @documents.each {|e| yield(e) }
    end

    def size
      @documents.size
    end

    def append(document)
      self.class.new(@documents + [document])
    end

    def to_a
      @documents
    end

    def left_outer_join(other)
      zip(other.pad_to(size))
        .inject(self.class.new) do |joined, pair|
          joined.append(pair[0].merge(pair[1]))
        end
    end

    def pad_to(padding_size)
      paddings = (padding_size - size).times.map { first }
      paddings.inject(self) do |r, p|
        r.append(p)
      end
    end
  end

  class DocumentGroup < Array

    def self.from_array(group)
      new(
        group.map {|document| Document.from_hash(document) }
      )
    end

    def group_by_schema
      h = group_by {|d| d.schema }
      h.values.map {|v| DocumentGroupWithSchema.new(v) }
    end

    def merge_document
      group_by_schema
        .sort {|a, b| b.size <=> a.size }
        .inject(&:left_outer_join)
    end
  end

  class << self

    def group_by_key(raw, key)
      h = raw.group_by {|e| e[key] }
      h.values.map {|v| DocumentGroup.from_array(v) }
    end

    def merge(raw, key: "key")
      return raw if raw.size == 1
      group_by_key(raw, key).inject([]) do |r, g|
        r += g.merge_document.to_a
      end
    end
  end
end
