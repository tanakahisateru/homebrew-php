require 'formula'

class Php54Uploadprogress < Formula
  homepage 'http://pecl.php.net/package/uploadprogress'
  url 'http://pecl.php.net/get/uploadprogress-1.0.3.1.tgz'
  md5 '13fdc39d68e131f37c4e18c3f75aeeda'
  head 'https://svn.php.net/repository/pecl/uploadprogress/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'pcre'
  depends_on 'php54'

  def php; Formula.factory 'php54' end

  def install
    Dir.chdir "uploadprogress-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "#{php.bin}/phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/uploadprogress.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-uploadprogress:
      * Add the following line to #{php.config_path}/php.ini:
        extension="#{prefix}/uploadprogress.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the uploadprogress module.
      * If you see it, you have been successful!
    EOS
  end
end
