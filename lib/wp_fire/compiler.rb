module WpFire
  class Compiler

    def self.compile(filename,build_path)
      extname = File.extname(filename)
      basename = File.basename(filename,extname)
      if not basename[0].eql?"_" and extname.eql?".scss"
        system "sass #{filename} #{File.join(build_path,basename)}"
      elsif extname.eql?".coffee"
        system "coffee -c -o #{build_path} #{filename}"
        File.rename File.join(build_path,"#{basename}.js"), File.join(build_path,basename)
      elsif extname.eql?".php"
        FileUtils.cp filename, File.join(build_path,File.basename(filename))
      end
    end

    def self.compile_all(filenames,build_path)
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
        compile f,build_path
      end
    end

    private

    def self.find(dir, filename="*.*", subdirs=true)
      Dir[ subdirs ? File.join(dir.split(/\\/), "**", filename) : File.join(dir.split(/\\/), filename) ]
    end

  end
end