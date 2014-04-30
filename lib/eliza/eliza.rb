
require 'eliza/key'
require 'eliza/memory'
require 'eliza/script'
require 'eliza/interpreter'

module Eliza
  class Eliza
    
    def initialize(scriptName='/scripts/original.txt', inputStream=nil, outputStream=nil)
      @debug = false
      @interpreter = Interpreter.new(scriptName)
      @in, @out = inputStream, outputStream
      srand 1234
    end
    
    def run
      @out.puts ">> Hello."
      @out.puts "Please state your problem."
      @out.print ">> "
      @in.each_line do |input|
        @out.print "#{input}" if @in.kind_of? File
        reply = @interpreter.process_input(input)
        @out.puts reply
        break if @interpreter.done
        @out.print ">> "
      end
    end

  end
end
