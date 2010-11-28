require 'uri'
require 'net/http'

class Download
  attr_reader :download_url

  def initialize
    puts "Creating new #{self.class.name}"
  end

  def install
    # This will get overridden
  end

  def post_install
  end

  private
    def download
      uri = URI.parse(@download_url)
      filename = nil
      Net::HTTP.start(uri.host) { |http|
        resp = http.get(uri.path)
        if (match = resp['content-disposition'].match(/filename=\"([^"]+)\"/)[1] rescue nil)
          filename = resp['content-disposition'].match(/filename=\"([^"]+)\"/)[1]
        else
          filename = File.basename uri.path
        end
        open(File.join('tmp', filename), "wb") { |file|
          file.write(resp.body)
        }
      }
      File.join('tmp', filename)
    end

    def system(cmd)
      result = `#{cmd}`
      raise Exception.new("Command failed: #{result}") if $?.to_i > 0
      result
    end
end
  
class Dmg < Download
    def install(cached_filename = nil)
      # download @download_url
      puts "  downloading"
      file = cached_filename ? File.join("tmp", cached_filename) : download
      # mount @disk_image
      puts "  mounting disk image"
      mount_dir = system(%{hdiutil attach #{file} | grep Volumes | awk -F\\t '{print $3}'}).strip
      # copy app
      if find_app(mount_dir)
        puts "  copying #{find_app(mount_dir)}"
        system(%{cp -pR "#{find_app(mount_dir)}" /Applications/})
      else
        puts "  installing package #{find_pkg(mount_dir)}"
        system(%{sudo installer -pkg "#{find_pkg(mount_dir)}" -target "/"})
      end
      # unmount dmg
      puts "  unmounting!"
      resp = system(%{hdiutil detach "#{mount_dir}"})
      # delete(?) dmg
      true
    end

    private
      def unzip(filename)
        system("unzip #{filename}")
      end
      def find_pkg(dir)
        Dir.glob("#{dir}/*.pkg").first
      end
      def find_app(dir)
        Dir.glob("#{dir}/*.app").first
      end
  end

class ZippedApp < Download
  attr_accessor :app_name
  def install(cached_filename = nil)
    puts "  downloading"
    file = cached_filename ? File.join("tmp", cached_filename) : download

    puts "  unzipping"
    result = system(%{unzip -q "#{file}" -d tmp})

    puts "  moving into /Applications"
    result = system(%{mv "#{File.join('tmp', @app_name)}.app" /Applications/})
    true
  end
end

class Tgz < Download
  def install
    # download @download_url
    # tar xzvf @tgz
    # do stuff
    # rm
  end
end

class DockApp < Download
  def install(cached_filename = nil)
    puts "  downloading"
    file = cached_filename ? File.join("tmp", cached_filename) : download

    puts "  unzipping"
    results = system(%{unzip -q "#{file}" -d tmp})
    
    puts "  opening"
    wdgt_file = File.join('tmp', "#{@app_name}.wdgt")
    system(%{open "#{wdgt_file}"})
    true
  end
end