##
# This class is the handler of the command line part and calls the class to
# get and process the infomation from github api.
require 'optparse'
require 'ostruct'
require_relative 'github'
class Favorite
  def self.parse(args)

    options = OpenStruct.new
    options.username  = nil
    options.verbose   = false
    options.version   = "0.1"

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: favorite.rb [options] -u GITHUB-USERNAME"

      opts.on("-u", "--username GITHUB-USERNAME", "Set github username to see favourite language") do |u|
        options.username = u
      end

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options.verbose = v
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      opts.on_tail("--version", "Show version") do
        puts "#{self.name} #{options.version}"
        exit
      end
    end

    begin
      opt_parser.parse!(args)

      raise OptionParser::MissingArgument, "GITHUB-USERNAME" if options.username.nil?

      puts "The user's favorite(s) language(s): #{Github.new({:username => options.username}).max_languages_names}"
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      puts $!.to_s
      puts opt_parser
      exit
    end

  end
end
options = Favorite.parse(ARGV)