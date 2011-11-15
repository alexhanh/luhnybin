# Author: Alexander Hanhikoski (alexander.hanhikoski)

def debug(s)
  $stderr.puts(s)
end

def output(s)
  # debug s
  print s
end

class Masker
  
  def initialize()
    @digits = "0123456789"
    
    reset
  end
    
  def store_char(c)
    is_digit = @digits.include? c
    return false unless is_digit or c == ' ' or c == '-'
    
    if is_digit
      @digit_count += 1
      @digit_indices << @current_index
    end

    @current_index += 1
    @chars += c
    
    return true
  end

  def reset
    @digit_count = 0
    @digit_indices = []
    @current_index = 0
    @chars = ""
  end
  
  # prints out the string to STDOUT while masking out credit cards it finds
  def mask
    # can't contain a valid credit card number, so return immediately
    if @digit_count < 14
      output @chars
      reset
      return
    end

    # holds indexes of the characters we should mask in the 'chars' string
    masks = {}
    
    # holds the maximum credit card length the string can contain
    # ie. if we know that a string has only 15 digits, we shouldn't check for 16 digit credit cards
    max_cc_length = [@digit_count, 16].min 
  
    # check credit cards with different lengths, starting from 14
    for cc_length in 14..max_cc_length do
    
      start_index = 0
      end_index = cc_length - 1
      
      # use brute-force to test out all possibilities
      while end_index < @digit_count do
        
        if credit_card?(start_index, end_index)
          for i in start_index..end_index do
            masks[@digit_indices[i]] = true
          end
        end

        start_index += 1
        end_index += 1
      end
    end
    
    # print out the solution
    for i in 0..(@chars.length - 1) do
      if masks.has_key?(i)
        output 'X'
      else
        output @chars[i]
      end
    end
    
    reset
  end

  def credit_card?(start_index, end_index)
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

masker = Masker.new
$stdin.each do |line|
  line.each_char do |c|
    if masker.store_char(c)
      next
    end
    
    masker.mask
    output c
  end
  
  $stdout.flush
end