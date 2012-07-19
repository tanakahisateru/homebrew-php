require 'formula'

class Php53Mcrypt < Formula
  homepage 'http://php.net/manual/en/book.mcrypt.php'
  url 'http://www.php.net/get/php-5.3.13.tar.bz2/from/this/mirror'
  md5 '370be99c5cdc2e756c82c44d774933c8'
  version '5.3.13'

  depends_on 'autoconf' => :build
  depends_on 'mcrypt'
  depends_on 'php53'

  def php; Formula.factory 'php53' end

  def install
    Dir.chdir "ext/mcrypt"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary unless Hardware.is_64_bit?

    system "#{php.bin}/phpize"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-mcrypt=#{Formula.factory('mcrypt').prefix}"
    system "make"
    prefix.install "modules/mcrypt.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php53-mcrypt:
      * Add the following line to #{php.config_path}/php.ini:
        extension="#{prefix}/mcrypt.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the mcrypt module.
      * If you see it, you have been successful!
    EOS
  end
end
