module Eliza
  class Decomp < Array
    attr_accessor :pattern
    attr_reader :mem

    def initialize(pattern, mem = false)
      super()
      @pattern = pattern  # a regular expression, see Script#initialize
      @mem     = mem      # save my dialogs in memory?
      @index   = nil      # locates current reassembly rule
    end

    def next_rule
      fail 'error: no reassembly rules for decomp' unless size
      @index = rand size unless @index
      if @mem
        @index = rand size
      else
        @index += 1
        @index = 0 unless 0 <= @index && @index < size
      end
      String.new self[@index]
    end

    def inspect
      "*** Decomp#inspect: @pattern=#{@pattern}, " \
      "@mem=#{@mem}, @index=#{@index} " + super
    end

    def to_s
      "*** Decomp#to_s: @pattern=#{@pattern}, " \
      "@mem=#{@mem}, @index=#{@index} " + super
    end
  end
end
