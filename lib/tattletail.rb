# -*- encoding: utf-8 -*-
require 'benchmark'
require 'colorful'
require 'tattletail/version'

module Tattletail
  COLORS = { :count => '00a0b0',
             :file => '444',
             :context => '999',
             :self => '793A57',
             :method => 'fff',
             :args => 'EB6841',
             :result => '2DE04D',
             :result_yaml => '105023',
             :time_good => 'EDC951',
             :time_bad => 'CC333F' }

  def self.reset
    $_tma_count = 0
    $_tma_indent = 0
    $_tma_last_indent = 0
  end

  def self.inc
    $_tma_count += 1
  end

  def self.indent
    $_tma_indent += 1
  end

  def self.outdent
    $_tma_indent -= 1
  end

  def self.remember_indent
    $_tma_last_indent = $_tma_indent
  end

  def self.count
    $_tma_count ||= 0
  end

  def self.indent_level
    $_tma_indent ||= 0
  end

  def self.indent_changed?
    $_tma_indent < $_tma_last_indent
  end

  def self.count_str
    " ##{count.to_s} ".color(COLORS[:count]).bold
  end

  def self.self_str passed_self
    passed_self.to_s.color(COLORS[:self])
  end

  def self.file_str method_caller
    file_name, line_number = method_caller[0].split(':', 3)
    "#{file_name}:#{line_number}".color(COLORS[:file])
  end

  def self.context_str method_caller
    file_name, line_number, context = method_caller[0].split(':', 3)
    begin
      actual_line = File.readlines(file_name)[line_number.to_i - 1].strip
    rescue Exception => e
      actual_line = "Unable to open #{file_name}:#{line_number}"
    end
    "#{context} ... #{actual_line}".color(COLORS[:context])
  end

  def self.method_str method_name, *args
    name_str = "#{method_name}".bold
    args_str = "(#{args.map {|a| a.inspect.size > 150 ? a.to_s : a.inspect}.map {|a| a.color(COLORS[:args])}.join(', ')})"
    name_str + args_str
  end

  def self.indent_str
    indent_level.times.inject('') {|m| m += " │ "}
  end

  def self.start_indent_str
    indent_str.reverse.sub(" │", "─├").reverse + "─┬─"
  end

  def self.cont_indent_str
    "#{indent_str} │ "
  end

  def self.end_indent_str
    "#{indent_str} └─"
  end

  def self.time_str seconds
    time_str = (' ' * count.to_s.size) + ("%.4f sec" % seconds)
    seconds > 0.05 ? time_str.color(COLORS[:time_bad]) : time_str.color(COLORS[:time_good])
  end

  def self.result_str result, indent_str
    result.to_s.color(COLORS[:result]) + if result.instance_variables.any? && ENV['SHOW_YAML']
                          "\n" + indent_str + "         " + result.to_yaml.each_line.map do |l|
                            l.gsub(/\n/,'').color(COLORS[:result_yaml])
                          end.join("\n").gsub(/\n/, "\n#{indent_str}           ")
                        else
                          ''
                        end
  end

  def tattle_on(*method_names)
    method_names.each do |method_name|
      if class_method? method_name
        tattle_on_class_method method_name
      else
        tattle_on_instance_method method_name
      end
    end
  end
  alias tell_on tattle_on
  alias tell_me_about tattle_on

  def tattle_on_class_method(*method_names)
    method_names.each do |method_name|
      class_eval <<-EOS, __FILE__, __LINE__ + 1
        class << self
          #{make_talk method_name}
        end
      EOS
    end
  end
  alias tattle_on_class_methods tattle_on_class_method
  alias tell_on_class_methods tattle_on_class_method
  alias tell_on_class_method tattle_on_class_method
  alias tell_me_about_class_methods tattle_on_class_method
  alias tell_me_about_class_method tattle_on_class_method

  def tattle_on_instance_method(*method_names)
    method_names.each do |method_name|
      class_eval <<-EOS, __FILE__, __LINE__ + 1
        #{make_talk method_name}
      EOS
    end
  end
  alias tattle_on_instance_methods tattle_on_instance_method
  alias tell_on_instance_methods tattle_on_instance_method
  alias tell_on_instance_method tattle_on_instance_method
  alias tell_me_about_instance_methods tattle_on_instance_method
  alias tell_me_about_instance_method tattle_on_instance_method

private

  def class_method? method_name
    class_eval { respond_to? method_name }
  end

  def make_talk method_name
    original_method = "_quiet_#{method_name}"
    <<-EOF
      if method_defined?(:#{original_method})
        return
      end
      alias #{original_method} #{method_name}

      def #{method_name}(*args, &blk)
        Tattletail.inc

        count_str = Tattletail.count_str

        indent_str = Tattletail.indent_str
        start_indent_str = Tattletail.start_indent_str
        cont_indent_str = Tattletail.cont_indent_str
        end_indent_str = Tattletail.end_indent_str

        method_str = Tattletail.method_str :#{method_name}, *args
        file_str = Tattletail.file_str(caller)
        context_str = Tattletail.context_str(caller)
        self_str = Tattletail.self_str(self)

        if defined?(Rails)
          file_str.sub!(Rails.root.to_s, '')
        end

        puts indent_str
        puts start_indent_str + count_str + self_str + "." + method_str + " called"
        puts "\#{cont_indent_str}      \#{file_str}"
        puts "\#{cont_indent_str}        \#{context_str}"

        Tattletail.indent
        result = nil
          seconds = Benchmark.realtime { result = #{original_method}(*args, &blk) }
          time_str = Tattletail.time_str(seconds)
          result_str = Tattletail.result_str(result, indent_str)
          Tattletail.outdent

          puts cont_indent_str if Tattletail.indent_changed?
          puts end_indent_str + count_str + self_str + "." + method_str + " ⊢ " + result_str

          Tattletail.remember_indent

          puts indent_str + "       " + time_str

          result
      end
    EOF
  end

end

Tattletail.reset

class Object
  extend Tattletail
end

class Fib
  def no_args
    5
  end
  tattle_on :no_args

  def fib x
    return 1 if x <= 2
    fib(x - 1) + fib(x - 2)
  end
  tattle_on_instance_method :fib

  def self.fib x
    return 1 if x <= 2
    fib(x - 1) + fib(x - 2)
  end
  tattle_on :fib

  def self.find x
    return 1 if x <= 2
    find(x - 1) + find(x - 2)
  end
  tattle_on_class_method :find

  def find x
    x * 2
  end
  tell_on_instance_method :find

  def fib_block &blk
    fib yield
  end
  tell_on :fib_block
end

module Merge
  extend Tattletail

  def self.sample_array
    [3,7,5,1,2,9,8,0,2,3,5,2,4,1,6,7,8,4,6,2,1]
  end

  def self.mergesort(list = sample_array)
    return list if list.size <= 1
    mid = list.size / 2
    left  = list[0, mid]
    right = list[mid, list.size]
    merge(mergesort(left), mergesort(right))
  end
  tattle_on :mergesort

  def self.merge(left, right)
    sorted = []
    until left.empty? or right.empty?
      if left.first <= right.first
        sorted << left.shift
      else
        sorted << right.shift
      end
    end
    sorted.concat(left).concat(right)
  end
  tattle_on :merge
end
