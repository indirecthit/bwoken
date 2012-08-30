#!/usr/bin/env ruby -wKU

# This is a stripped down version of Alex Vollmer's tuneup_js run-test
# script from https://github.com/alexvollmer/tuneup_js.

require "fileutils"
require "optparse"
require "ostruct"
require "pty"

command = ["/usr/bin/instruments"] 
command << ARGV

failed = false

begin
  PTY.spawn(command.join ' ') do |r, w, pid|
    r.each do |line|
      _, date, time, tz, type, msg = line.match(/^(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2}) ([+-]\d{4}) ([^:]+): (.*)$/).to_a

      case type
      when "Fail"
        failed = true
      end
    end
  end     
rescue Errno::EIO
rescue PTY::ChildExited => e
  STDERR.puts "Instruments exited unexpectedly" 
  exit 1
end

if failed
  STDERR.puts "#{test_script} failed, see log output for details"
  exit 1
else
  STDOUT.puts "TEST PASSED"
end
