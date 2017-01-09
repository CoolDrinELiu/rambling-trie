module Rambling
  module Trie
    module Configuration
      # Provides configurable properties for Rambling::Trie.
      class Properties
        # The configured {Readers Readers}.
        # @return [ProviderCollection] the mapping of configured {Readers
        #   Readers}.
        attr_reader :readers

        # The configured {Serializers Serializers}.
        # @return [ProviderCollection] the mapping of configured {Serializers
        #   Serializers}.
        attr_reader :serializers

        # The configured {Compressor Compressor}.
        # @return [Compressor] the configured compressor.
        attr_accessor :compressor

        # The configured root_builder, which should return a {Node Node} when
        # called.
        # @return [Proc<Node>] the configured root_builder.
        attr_accessor :root_builder

        # Returns a new properties instance.
        def initialize
          reset
        end

        # Resets back to default properties.
        def reset
          reset_readers
          reset_serializers

          self.compressor = Rambling::Trie::Compressor.new
          self.root_builder = lambda { Rambling::Trie::RawNode.new }
        end

        private

        attr_writer :readers, :serializers

        def reset_readers
          plain_text_reader = Rambling::Trie::Readers::PlainText.new

          self.readers = Rambling::Trie::Configuration::ProviderCollection.new 'reader', txt: plain_text_reader
        end

        def reset_serializers
          marshal_serializer = Rambling::Trie::Serializers::Marshal.new
          yaml_serializer = Rambling::Trie::Serializers::Yaml.new

          self.serializers = Rambling::Trie::Configuration::ProviderCollection.new 'serializer',
            marshal: marshal_serializer,
            yml: yaml_serializer,
            yaml: yaml_serializer
        end
      end
    end
  end
end