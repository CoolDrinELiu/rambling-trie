module Rambling
  module Trie
    module Serializers
      # Zip file serializer. Dumps/loads contents from zip files. Automatically
      # detects if zip file contains `.marshal` or `.yml` file
      class Zip
        extend Rambling::Trie::Forwardable

        # Creates a new Zip serializer.
        # @param [Properties] properties the configuration properties set up so
        #   far.
        def initialize properties
          @properties = properties
        end

        # Unzip contents from specified filepath and load in contents from
        # unzipped files.
        # @param [String] filepath the filepath to load contents from.
        # @return [String] all contents of the unzipped loaded file.
        def load filepath
          require 'zip'

          ::Zip::File.open filepath do |zip|
            entry = zip.entries.first
            entry_path = path entry.name
            entry.extract entry_path

            serializer = serializers.resolve entry.name
            serializer.load entry_path
          end
        end

        # Dumps contents and zips into a specified filepath.
        # @param [String] contents the contents to dump.
        # @param [String] filepath the filepath to dump the contents to.
        # @return [Numeric] number of bytes written to disk.
        def dump contents, filepath
          require 'zip'

          ::Zip::File.open filepath, ::Zip::File::CREATE do |zip|
            filename = ::File.basename filepath, '.zip'

            entry_path = path filename
            serializer = serializers.resolve filename
            serializer.dump contents, entry_path

            zip.add filename, entry_path
          end
        end

        private

        attr_reader :properties

        delegate [
          :serializers,
          :tmp_path
        ] => :properties

        def path filename
          require 'securerandom'
          ::File.join tmp_path, "#{SecureRandom.uuid}-#{filename}"
        end
      end
    end
  end
end
