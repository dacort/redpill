module Apps
  class Git < Dmg
    def initialize
      @download_url = "http://git-osx-installer.googlecode.com/files/git-1.7.3.2-intel-leopard.dmg"
      super
    end
  end

  class TextMate < ZippedApp
    def initialize
      @app_name = "TextMate"
      @download_url = "http://dl.macromates.com/TextMate_1.5.10_r1623.zip"
      super
    end
  end

  class Chrome < Dmg
    def initialize
      @app_name = "Google Chrome"
      @download_url = "https://dl-ssl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
      super
    end
  end

  class Echofon < Dmg
    def initialize
      @download_url = "http://file.echofon.com/twitter/mac/bin/Echofon_1.3.dmg"
      super
    end
  end
  
  class Adium < Dmg
    def initialize
      @download_url = "http://download.adium.im/Adium_1.4.1.dmg"
      super
    end
  end

  class OnePassword < ZippedApp
    def initialize
      @app_name = "1Password"
      @download_url = "http://aws.cachefly.net/aws/dmg/1PW3/English/1Password-3.5.1.zip"
      super
    end
  end
  
  class GitX < ZippedApp
    def initialize
      @app_name = "GitX"
      @download_url = "http://frim.frim.nl/GitXStable.app.zip"
      super
    end
  end
  
  class IStatMenus < ZippedApp
    def initialize
      @app_name = "iStat Menus"
      @download_url = "http://s3.amazonaws.com/bjango/files/istatmenus3/istatmenus3.10.zip"
      super
    end
  end

  class Viscosity < Dmg
    def initialize
      @download_url = "http://c0001925.cdn1.cloudfiles.rackspacecloud.com/Viscosity1.2.2.dmg"
      super
    end
  end
  
  class IStatPro < DockApp
    def initialize
      @app_name = "iStat Pro"
      @download_url = "http://s3.amazonaws.com/bjango/files/istatpro/istat_pro_4.92.zip"
      super
    end
  end
  
  class RVM < Download
    def install
      results = `( curl http://rvm.beginrescueend.com/releases/rvm-install-head ) | bash -c $0`
      puts results
      true
    end
    
    def post_install
      system(%{echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc})
      true
    end
  end
end