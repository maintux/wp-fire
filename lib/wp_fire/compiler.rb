require 'coffee-script'
require 'sass'

module WpFire
  class Compiler

    def self.compile(filename, build_path, root_path)
      extname = File.extname(filename)
      basename = File.basename(filename, extname)
      if not basename[0].eql?"_" and extname.eql?".scss"
        sass_engine = Sass::Engine.for_file filename, {}
        File.open File.join(build_path, basename), "w" do |f|
          f.puts sass_engine.to_css
        end
      elsif basename[0].eql?"_" and extname.eql?".scss"
        parents_filename = []
        find_scss_parents(filename,parents_filename)
        parents_filename.uniq.each do |parent|
          compile parent, build_path, root_path
        end
      elsif extname.eql?".css"
        FileUtils.cp filename, File.join(build_path, File.basename(filename))
      elsif extname.eql?".coffee"
        File.open File.join(build_path, basename), "w" do |f|
          f.puts CoffeeScript.compile File.read(filename)
        end
      elsif extname.eql?".js"
        FileUtils.cp filename, File.join(build_path, File.basename(filename))
      elsif extname.eql?".php"
        FileUtils.cp filename, File.join(build_path, File.basename(filename))
      else
        dir = File.dirname(filename)
        dir = dir.sub(File.join(root_path,"source"),'')
        #unwrap from assets path for backward compatibility
        dir = dir.sub("assets",'')
        FileUtils.mkdir_p File.join(build_path, dir) unless File.directory?(File.join(build_path, dir))
        FileUtils.cp filename, File.join(build_path, dir, File.basename(filename))
      end

    end

    def self.compile_all(filenames, build_path, root_path)
      files = []
      filenames.each do |filename|
        if(File.directory?(filename))
          files = files + find(filename)
        end
        if(File.file?(filename))
          files << filename
        end
      end
      files.each do |f|
        compile f, build_path, root_path
      end
    end

    private

    def self.find(dir, filename="*.*", subdirs=true)
      Dir[ subdirs ? File.join(dir.split(/\\/), "**", filename) : File.join(dir.split(/\\/), filename) ]
    end

    def self.find_scss_parents(filename,parents_array)
      directory = File.dirname(filename)
      Dir["#{directory}/*.scss"].each do |f|
        if open(f).grep(/@import ["']#{File.basename(filename).gsub(/(_|\.scss)/,'')}["']/).any?
          if File.basename(f)[0].eql?"_" and not f.eql? filename
            find_scss_parents(f,parents_array)
          elsif not File.basename(f)[0].eql?"_"
            parents_array << f
          end
        end
      end
    end

  end
end