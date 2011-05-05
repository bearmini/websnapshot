require 'optparse'
require 'lib/websnapshot.rb'

module Websnapshot
  unless defined? Websnapshot::CLI

    class CLI
      def self.execute(stdout, arguments=[])

        options = {
          :max_width     => 960,
          :max_height    => 640,
        }
        mandatory_options = %w(  )

        parser = OptionParser.new do |opts|
          opts.banner = <<-BANNER.gsub(/^          /,'')
            This is an application to capture snapshot images of web pages.
          
            Usage: #{File.basename($0)} [options] [URL]...
          
            Options are:
          BANNER
          opts.separator ""
          opts.on("-x", "--max-width WIDTH", Integer,
                  "Maximum width (in pixels) of an artifact image.",
                  "If the page you want to take an snapshot image has ",
                  "width less than the specified value, the original size",
                  "will be preserved.",
                  "Default: 960") { |arg| options[:max_width] = arg }
          opts.on("-y", "--max-height HEIGHT", Integer,
                  "Maximum height (in pixels) of an artifact image.",
                  "If the page you want to take an snapshot image has ",
                  "height less than the specified value, the original size",
                  "will be preserved.",
                  "Default: 640") { |arg| options[:max_height] = arg }
          opts.on("-h", "--help",
                  "Show this help message.") { stdout.puts opts; exit }
          opts.on("-v", "--version",
                  "Show the version number of this application.") { stdout.puts Websnapshot::VERSION; exit }
          opts.parse!(arguments)

          if (mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }) || arguments.length == 0
            stdout.puts opts; exit
          end
        end

        # do stuff
        arguments.each do |url|
          Websnapshot::take(url, options)
        end
      end
    end
  end
end
