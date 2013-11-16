#!/usr/bin/ruby

class JavaParser
  attr_accessor :is_in_comment
  def initialize
    @is_in_comment = false
  end

  def parse_line(line)
    if !@is_in_comment
      if line =~ /\/\*/
        @is_in_comment = true
        return ""
      end
      if line =~ /[\{\}]+/
        return line.gsub(/([^\{\}])*/, "")
      end
      strip_line = line.strip
      ((strip_line.empty? || strip_line =~ /^\/\/.*/ || strip_line =~ /^import/ || strip_line =~ /^package/) && "") || "."
    else
      if line =~ /\*\//
        @is_in_comment = false
      end
      ""
    end
  end
end

if __FILE__ == $0
  filename = ARGV.pop
  file = File.new(filename, "r")
  parser = JavaParser.new
  file_summary = ""
  while (line = file.gets)
    file_summary << parser.parse_line(line)
  end
  summary_size = file_summary.length
  puts "#{filename}:#{summary_size}: #{file_summary}"
end
