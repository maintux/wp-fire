module WpFire
  class Generator

    def initialize(project_name, task, configuration)
      @project_name = project_name
      @task    = task
      @configuration  = configuration

      @source_path = File.join(project_name,"source")
      @config_file = File.join(project_name,"config.rb")
      @assets_path = File.join(project_name,"source","assets")
    end

    def create_structure
      source_paths = [
        ['assets', 'fonts'],
        ['assets', 'images'],
        ['assets', 'javascripts'],
        ['assets', 'stylesheets'],
        ['functions'],
        ['templates']
      ]

      source_paths.each do |path|
        @task.empty_directory File.join(@source_path, path)
      end

      self
    end

    def layout_path
      @layout_path ||= File.join(WpFire::ROOT, 'generators', 'wp_fire')
    end

    def write_config
      write_template(['generators', 'wp_fire', 'config', 'config.tt'], @config_file)
      self
    end

    def copy_javascript
      source = File.expand_path(File.join(self.layout_path, 'javascripts'))
      target = File.expand_path(File.join(@assets_path, 'javascripts'))

      render_directory(source, target)

      self
    end

    def copy_stylesheets
      source = File.expand_path(File.join(self.layout_path, 'stylesheets'))
      target = File.expand_path(File.join(@assets_path, 'stylesheets'))

      render_directory(source, target)

      self
    end

    def copy_templates
      if @configuration[:template].nil? or !File.directory?(File.join(@configuration[:template_path],@configuration[:template],"children_files"))
        source = File.expand_path(File.join(self.layout_path, 'templates'))
      else
        source = File.expand_path(File.join(@configuration[:template_path],@configuration[:template],"children_files"))
      end
      target = File.expand_path(File.join(@source_path, 'templates'))

      render_directory(source, target)

      self
    end

    def copy_functions
      source = File.expand_path(File.join(self.layout_path, 'functions', 'functions.php.erb'))
      target = File.expand_path(File.join(@source_path, 'functions', 'functions.php'))

      write_template(source, target)
    end

    def write_template(source, target)
      source   = File.join(source)
      template = File.expand_path(@task.find_in_source_paths((source)))
      target   = File.expand_path(File.join(target))

      @task.create_file target do
        parse_erb(template)
      end
    end

    def theme_id
      @project_name
    end

    private

    def parse_erb(file)
      ERB.new(::File.binread(file), nil, '-', '@output_buffer').result(binding)
    end

    def render_directory(source, target)
      Dir.glob("#{source}/**/*") do |file|
        unless File.directory?(file)
          source_file = file.gsub(source, '')
          target_file = File.join(target, source_file)

          if source_file.end_with? ".erb"
            target_file = target_file.slice(0..-5)

            content = parse_erb(file)
          else
            content = File.open(file).read
          end

          @task.create_file target_file do
            content
          end
        end
      end
    end

  end
end