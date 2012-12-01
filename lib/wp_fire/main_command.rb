#! /usr/bin/env ruby
require 'rubygems'
require 'clamp'
require 'forge'
require 'thor'
require 'filewatcher'
require 'zip/zip'

class ThorUtils < Thor
  include Thor::Actions

  def self.source_root
    WpFire::ROOT
  end
end

module WpFire

  class BuildCommand < Clamp::Command

    parameter "DIR", "The theme root path"

    def execute
      @assets_path = File.join(dir,"source","assets")
      @templates_path = File.join(dir,"source","templates")
      @functions_path = File.join(dir,"source","functions")

      @build_path = File.join(dir,"build")
      Dir.unlink(@build_path) if File.directory?(@build_path)
      Dir.mkdir @build_path
      Dir[File.join(dir.split(/\\/), "*.*")].each do |f|
        File.unlink f unless File.basename(f).eql? "config.rb"
      end
      watch_directories = [@assets_path,@templates_path,@functions_path]
      WpFire::Compiler.compile_all watch_directories, @build_path
    end

  end

  class WatchCommand < Clamp::Command

    parameter "DIR", "The theme root path"
    option ["-p","--build-path"], "BUILD_PATH", "Build path. The default is the theme root path", :default => nil

    def execute
      @assets_path = File.join(dir,"source","assets")
      @templates_path = File.join(dir,"source","templates")
      @functions_path = File.join(dir,"source","functions")

      if build_path and File.directory?(build_path)
        @build_path = build_path
      else
        @build_path = dir
      end

      Dir[File.join(dir.split(/\\/), "*.*")].each do |f|
        File.unlink f unless File.basename(f).eql? "config.rb"
      end
      watch_directories = [@assets_path,@templates_path,@functions_path]
      WpFire::Compiler.compile_all watch_directories, @build_path

      FileWatcher.new(watch_directories,"Watching files:").watch do |filename|
        WpFire::Compiler.compile filename, @build_path
      end
    end

  end

  class CreateCommand < Clamp::Command

    parameter "NAME", "Theme Name"
    option ["-t","--template"], "TEMPLATE", "Template for new theme", :default => nil
    option ["--template-path"], "TEMPLATE_PATH", "Template theme path", :default => nil
    option "--theme-uri", "THEME_URI", "Theme URI", :default => "http://www.dsmart.it"
    option ["-a", "--author"], "AUTHOR", "Theme author", :default => "dSmart s.r.l."
    option "--author-uri", "AUTHOR_URI", "Author URI", :default => "http://www.dsmart.it"
    option ["-d", "--description"], "DESCRIPTION", "Theme description", :default => nil
    option ["-v", "--version"], "VERSION", "Theme version", :default => "0.0.1"
    option ["-l", "--license"], "LICENSE", "License name", :default => "Copyright #{Time.now.year} dSmart s.r.l."

    def execute
      if template and !template.eql?""
        raise ArgumentError, "Error! --template-path is required because you have specified --template" if template_path.nil?
      end
      if template_path and !File.directory? template_path
        raise ArgumentError, "Error! template-path not found."
      end
      name = @name.gsub(/\W/, '_')

      thor_actions = ThorUtils.new
      generator = WpFire::Generator.new(name, thor_actions, generate_config)
      generator.create_structure
      generator.write_config
      generator.copy_javascript
      generator.copy_stylesheets
      generator.copy_functions
      generator.copy_templates
    end

    private

    def generate_config
      config = {}
      config[:name] = "#{name}"
      config[:uri] = "#{theme_uri}"
      config[:author] = "#{author}"
      config[:author_uri] = "#{author_uri}"
      config[:description] = "#{description}"
      config[:version_number] = "#{version}"
      config[:template] = "#{template}" if template
      config[:template_path] = "#{template_path}" if template_path
      config[:license_name] = "#{license}"
      config
    end
  end

  class MainCommand < Clamp::Command
    subcommand "create", "Create new WordpressTheme", CreateCommand
    subcommand "watch", "Watch for change in assets", WatchCommand
    subcommand "build", "Build theme", BuildCommand
  end
end
