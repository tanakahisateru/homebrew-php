require 'formula'

class Php53Memcached < Formula
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.0.1.tgz'
  md5 'f81a5261be1c9848ed5c071a4ebe5e05'
  head 'https://github.com/php-memcached-dev/php-memcached.git'

  depends_on 'autoconf' => :build
  depends_on 'libmemcached'
  depends_on 'php53'

  def php; Formula.factory 'php53' end

  def install
    Dir.chdir "memcached-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "#{php.bin}/phpize"
    system "./configure", "--prefix=#{prefix}",
                          "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"
    system "make"
    prefix.install "modules/memcached.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php53-memcached:
      * Add the following line to #{php.config_path}/php.ini:
        extension="#{prefix}/memcached.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the memcached module.
      * If you see it, you have been successful!
    EOS
  end
end
