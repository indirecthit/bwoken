require 'fileutils'
require 'open3'

require 'bwoken/build'

module Bwoken

  class ScriptFailedError < RuntimeError; end

  class Script

    attr_accessor :path

    class << self

      def run_all device_family
        Simulator.device_family = device_family

        test_files(device_family).each do |javascript|
          run(javascript)
        end
      end

      def run_one feature_name, device_family
        Simulator.device_family = device_family
        run File.join(Bwoken.test_suite_path, device_family, "#{feature_name}.js")
      end

      def run javascript_path
        script = new
        script.path = javascript_path
        script.run
      end

      def trace_file_path
        File.join(Bwoken.tmp_path, 'trace')
      end

      def test_files device_family
        all_files_in_test_dir = Dir["#{Bwoken.test_suite_path}/#{device_family}/**/*.js"]
        helper_files = Dir["#{Bwoken.test_suite_path}/#{device_family}/**/helpers/**/*.js"]
        all_files_in_test_dir - helper_files
      end

    end

    def env_variables
      {
        'UIASCRIPT' => path,
        'UIARESULTSPATH' => Bwoken.results_path
      }
    end

    def env_variables_for_cli
      env_variables.map{|key,val| "-e #{key} #{val}"}.join(' ')
    end

    def cmd
      build = Bwoken::Build.new
      "#{File.expand_path('../../../bin', __FILE__)}/unix_instruments.rb \
        #{device_flag} \
        -D #{self.class.trace_file_path} \
        -t #{Bwoken.path_to_automation_template} \
        #{build.app_dir} \
        #{env_variables_for_cli}"
    end

    def device_flag
      if Bwoken::Device.connected?
        "-w #{Bwoken::Device.uuid}"
      else
        ''
      end
    end

    def make_results_path_dir
      FileUtils.mkdir_p Bwoken.results_path
    end

    def run
      Bwoken.formatter.before_script_run path
      make_results_path_dir

      exit_status = 0
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        exit_status = Bwoken.formatter.format stdout
      end
      raise ScriptFailedError.new('Test Script Failed') unless exit_status == 0
    end

  end
end
