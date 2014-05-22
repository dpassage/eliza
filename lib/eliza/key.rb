module Eliza
  class Key < Array
    include Comparable
    attr_reader :name, :rank, :index

    def <=>(other)
      comparison = rank <=> other.rank
      comparison = other.index <=> index if comparison == 0
      comparison
    end

    def initialize(name = nil, rank = 0, index = 0)
      super()
      @name = name    # name of key
      @rank = rank    # a precedence
      @index = index  # offset of key in original script
    end

    def inspect
      "*** Key#inspect: @name=#{@name}, @rank=#{@rank}, @index=#{@index} " +
        super
    end

    def to_s
      "*** Key#to_s: @name=#{@name}, @rank=#{@rank}, @index=#{@index} " +
        super
    end
  end
end
