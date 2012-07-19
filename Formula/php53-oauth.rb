require 'formula'

class Php53Oauth < Formula
  homepage 'http://pecl.php.net/package/oauth'
  url 'http://pecl.php.net/get/oauth-1.2.2.tgz'
  md5 '9a9f35e45786534d8580abfffc8c273c'
  head 'https://svn.php.net/repository/pecl/oauth/trunk', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'php53'

  def php; Formula.factory 'php53' end

  def install
    Dir.chdir "oauth-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "#{php.bin}/phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/oauth.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php53-oauth:
      * Add the following line to #{php.config_path}/php.ini:
        extension="#{prefix}/oauth.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the oauth module.
      * If you see it, you have been successful!
    EOS
  end
end
