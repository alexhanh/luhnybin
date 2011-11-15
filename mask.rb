def debug(s)
  $stderr.puts(s)
end

def output(s)
  # debug s
  print s
end

class Masker
  
  def initialize()
    reset
  end
  
  def store_char(c)
    if "0123456789".include? c
      @digit_count += 1
      @digit_indices << @current_index
    end

    @current_index += 1
    @chars += c
  end

  def reset
    @digit_count = 0
    @digit_indices = []
    @current_index = 0
    @chars = ""
  end

  # would storing start-end index pairs be faster instead of a masks hash?
  def print_solution    
    # can't contain a valid credit card number, so return immediately
    if @digit_count < 14
      output @chars
      return
    end

    masks = {} # holds indexes of characters which should be masked
    max_cc_length = [@digit_count, 16].min
  
    for cc_length in 14..max_cc_length do
      start_index = 0
      end_index = cc_length - 1
    
      while end_index < @digit_count do
      
        if is_cc?(start_index, end_index)
          for i in start_index..end_index do
            masks[@digit_indices[i]] = true
          end
        end

        start_index += 1
        end_index += 1
      end
    end
  
    for i in 0..(@chars.length-1) do
      if masks.has_key?(i)
        output 'X'
      else
        output @chars[i]
      end
    end
  end

  def is_cc?(start_index, end_index)
    odd = true
    sum = 0
    
    end_index.downto(start_index) do |i|
      d = @chars[@digit_indices[i]].to_i
      
      d *= 2 if odd = !odd
      sum += d > 9 ? d - 9 : d
    end
  
    sum % 10 == 0
  end
end

cc_chars = "0123456789 -"
masker = Masker.new

line_feeds = 0
begin
  c = $stdin.getc
  
  if cc_chars.include? c
    masker.store_char(c)
    next
  end
    
  masker.print_solution
  masker.reset
  
  output c
  
  if c == "\n"
    line_feeds += 1 
  end
  
end while line_feeds <= 20