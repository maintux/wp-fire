require 'coffee-script'
require 'sass'

module WpFire
  class Compiler

    def self.compile(filename, build_path)
      extname = File.extname(filename)
      basename = File.basename(filename, extname)
      if not basename[0].eql?"_" and extname.eql?".scss"
        sass_engine = Sass::Engine.for_file filename, {}
        File.open File.join(build_path, basename), "w" do |f|
          f.puts sass_engine.to_css
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
      elsif [".jpg",".jpeg",".png",".gif",".ico"].include?(extname)
        Dir.mkdir File.join(build_path, "images") unless File.directory?(File.join(build_path, "images"))
        FileUtils.cp filename, File.join(build_path, "images", File.basename(filename))
      elsif [".ttf",".eot",".woff",".svg",".otf"].include?(extname)
        Dir.mkdir File.join(build_path, "fonts") unless File.directory?(File.join(build_path, "fonts"))
        FileUtils.cp filename, File.join(build_path, "fonts", File.basename(filename))
      end
    end

    def self.compile_all(filenames, build_path)
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
        compile f, build_path
      end
    end

    private

    def self.find(dir, filename="*.*", subdirs=true)
      Dir[ subdirs ? File.join(dir.split(/\\/), "**", filename) : File.join(dir.split(/\\/), filename) ]
    end

  end
end