class ProgressBar
  def initialize(total)
    @total  = total
    @counter = 1
  end

  def increment
    complete = sprintf("%#.2f%%", ((@counter.to_f / @total.to_f) * 100))
    print "\n\n\r\e[0K#{@counter}/#{@total} (#{complete})".green
    @counter += 1
  end
end
