require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Pspell < AbstractPhpExtension
  homepage 'http://php.net/manual/en/book.pspell.php'
  url 'http://www.php.net/get/php-5.3.16.tar.bz2/from/this/mirror'
  sha1 'a8356b18f6413a87451bd70110b814c847b69f00'
  version '5.3.16'

  depends_on 'aspell'
  depends_on 'autoconf' => :build
  depends_on 'php53' if build.include?('with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "ext/pspell"

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-debug",
                          "--with-pspell=#{Formula.factory('aspell').prefix}"
    system "make"
    prefix.install "modules/pspell.so"
    write_config_file unless build.include? "without-config-file"
  end
end
