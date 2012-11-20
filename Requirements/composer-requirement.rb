require File.join(File.dirname(__FILE__), 'homebrew-php-requirement')

class ComposerRequirement < HomebrewPhpRequirement
  COMMAND = 'curl -s http://getcomposer.org/installer | /usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off -d date.timezone=UTC -- --check'

  def satisfied?
    @result = `#{COMMAND}`
    @result.include? "All settings correct"
  end

  def message
      result_indented = @result.to_s.sub(/^#!.*\n/, '').gsub(/^/, "    ")
<<-EOS
Composer PHP requirements check has failed. Checking environment with:

    #{COMMAND}

was failed by reason below:

#{result_indented}
EOS
  end
end
