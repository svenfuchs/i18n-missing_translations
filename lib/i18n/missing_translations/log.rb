require 'yaml'
require 'fileutils'

module I18n
  class MissingTranslations
    class Log < Hash
      def log(keys)
        keys = keys.dup
        key = keys.pop.to_s
        log = keys.inject(self) { |log, k| log.key?(k.to_s) ? log[k.to_s] : log[k.to_s] = {} }
        log[key] = key.to_s.gsub('_', ' ').gsub(/\b('?[a-z])/) { $1.capitalize }
      end

      def dump(out = $stdout)
        out.puts(to_yml) unless empty?
      end

      def read(filename)
        data = YAML.load_file(filename) rescue nil
        self.replace(data) if data
      end

      def write(filename)
        FileUtils.mkdir_p(File.dirname(filename))
        File.open(filename, 'w+') { |f| f.write(to_yml) }
      end

      def to_yml
        empty? ? '' : YAML.dump(Hash[*to_a.flatten])
      end
    end
  end
end
