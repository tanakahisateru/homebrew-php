require 'formula'

class Php54Memcache < Formula
  homepage 'http://pecl.php.net/package/memcache'
  url 'http://pecl.php.net/get/memcache-2.2.6.tgz'
  md5 '9542f1886b72ffbcb039a5c21796fe8a'
  head 'https://svn.php.net/repository/pecl/memcache/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php54'

  def php; Formula.factory 'php54' end

  def install
    Dir.chdir "memcache-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "#{php.bin}/phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/memcache.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-memcache:
      * Add the following line to #{php.config_path}/php.ini:
        extension="#{prefix}/memcache.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the memcache module.
      * If you see it, you have been successful!
    EOS
  end
end
