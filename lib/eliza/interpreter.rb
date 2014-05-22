require 'eliza/memory'
require 'eliza/script'

module Eliza
  class Interpreter
    attr_reader :done

    def initialize(script_name = '/scripts/original.txt')
      @memory = Memory.new
      @memory.save('Oh my gosh, I spilled coffee! Sorry, please continue.')
      @script = Script.new File.dirname(__FILE__) + script_name
      @done = false
    end

    def last_response
      "Hello, I am Dr. Eliza.\nPlease describe your problem.\n"
    end

    def process_input(input)
      # Clean up input string, split into sentences.
      # str = input.tr(',?!', '.').gsub(/[^.'\w]/, ' ').strip.squeeze("\s.")
      str = input.tr(',?!', '.').strip.squeeze("\s.")
      sentences = str.split(/\.\s*/)

      # Try each sentence in string.
      sentences.each { |s| (reply = sentence(s)) && (return reply) }

      # No sentence(), pop next FIFO memory, if any.
      (reply = @memory.get) && (return reply)

      # No memory, try processing with xnone key.
      results = {}
      if (key = @script.keys['xnone'])
        sentences.each do |s|
          decompose(s, key, results) &&
            results['reply'] &&
            (return results['reply'])
        end
      end

      # Oh well, just say anything.
      'I am at a loss for words.'
    end

    # rubocop:disable CyclomaticComplexity
    def sentence(s)
      puts %Q(*** processing sentence "#{s}" ...) if @debug

      results = {} # for results of decomp and assemble

      # Pre-replace any matching source terms with their destination.
      s = @script.pre_translate(s)

      # Check special case = end of therapy session.
      if @script.quits.include? s
        @done = true
        return @script.final
      end

      # Patient isn't done, collect all keywords.
      keys = {} # Start as hash,
      s.split.each do |word|
        keys[word] = @script.keys[word] if @script.keys[word]
      end
      keys = keys.each_value.sort.reverse # end as array, decreasing precedence

      # Try each key for a reply or goto rule.
      keys.each do |key|
        next unless decompose(s, key, results)
        return results['reply'] if results['reply']
        # Avoid infinite loops, allow one goto.
        next unless decompose(s, results['goto_key'], results)
        return results['reply'] if results['reply']
      end

      # Sorry Charlie, no match found!
      nil
    end
    # rubocop:enable CyclomaticComplexity

    def decompose(input, key, results)
      puts %Q(*** decompose "#{input}" on key "#{key.name}") if @debug
      key.each do |decomp|
        md = decomp.pattern.match(input)
        return true if md && assemble(md, decomp, results)
      end
      false
    end

    # rubocop:disable CyclomaticComplexity
    def assemble(md_input, decomp, results)
      if @debug
        captures = %Q("#{md_input.captures.join('", "')}")
        puts %Q{*** assemble "#{decomp.pattern.inspect}" with (#{captures})}
      end
      rule = decomp.next_rule
      if rule =~ /^goto\s+(\w+)/
        fail "error: unknown key '#{$1}'" unless @script.keys[$1]
        return (results['goto_key'] = @script.keys[$1])
      end
      # rubocop:disable AssignmentInCondition
      while md_rule = /(\((\d)\))/.match(rule) # e.g., (2) => md_input[2]
        i, arg = $2.to_i, "[#{i}]"
        if (0 < i) && (i < md_input.length)
          arg = @script.post_translate(md_input[i])
          rule = md_rule.pre_match + arg + md_rule.post_match
        end
      end
      # rubocop:enable AssignmentInCondition
      rule.sub!(/\s*(\W)\Z/) { $1 }
      @memory.save(rule) if decomp.mem
      results['reply'] = rule
    end
    # rubocop:enable CyclomaticComplexity
  end
end
