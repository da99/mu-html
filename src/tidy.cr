
#
# This is  used for testing the output of Mu_WWW_HTML
#
def tidy(*args)
  input  = nil
  output = IO::Memory.new
  error  = IO::Memory.new
  cmd    = ["tidy5", "-config", "tidy.config.txt"]

  args.each do |arg|
    case
    when File.file?(arg)
      cmd << arg

    when arg =~ /\<.+\>/
      input ||= IO::Memory.new
      input << arg
      input << "\n"
      input.rewind

    else
      arg.split.each do |w|
        cmd << w
      end

    end # === case
  end # === args.each

  stat = Process.run(cmd.shift, cmd, output: output, error: error, input: input)

  if !stat.success? || !error.empty? || !stat.normal_exit? || stat.signal_exit?
    STDERR.puts error.rewind.to_s
    STDERR.puts output.rewind.to_s
    STDERR.puts "Exit code:   #{stat.exit_code}"
    STDERR.puts "Exit signal: #{stat.exit_signal}" if stat.signal_exit?
    Process.exit stat.exit_code
  end

  return output.rewind.to_s
end # === def tidy5


