require 'spec_helper'

describe Rambling::Trie::Container do
  let(:container) { Rambling::Trie::Container.new root }
  let(:root) do
    double :root,
      add: nil,
      each: nil,
      word?: nil,
      partial_word?: nil,
      scan: nil,
      compress!: nil,
      compressed?: nil
  end

  describe '.new' do
    context 'without a specified root' do
      before do
        allow(Rambling::Trie::Root).to receive(:new)
          .and_return root
      end

      it 'initializes an empty trie root node' do
        Rambling::Trie::Container.new
        expect(Rambling::Trie::Root).to have_received :new
      end
    end

    context 'with a block' do
      it 'yields the container' do
        yielded_container = nil

        container = Rambling::Trie::Container.new root do |container|
          yielded_container = container
        end

        expect(yielded_container).to eq container
      end
    end
  end

  describe '#add' do
    let(:clone) { double :clone }
    let(:word) { double :word, clone: clone }

    it 'clones the original word' do
      container.add word
      expect(root).to have_received(:add).with clone
    end
  end

  describe 'delegates and aliases' do
    it 'aliases `#include?` to `#word?`' do
      container.include? 'words'
      expect(root).to have_received(:word?).with 'words'
    end

    it 'aliases `#match?` to `#partial_word?`' do
      container.match? 'words'
      expect(root).to have_received(:partial_word?).with 'words'
    end

    it 'aliases `#words` to `#scan`' do
      container.words 'hig'
      expect(root).to have_received(:scan).with 'hig'
    end

    it 'aliases `#<<` to `#add`' do
      container << 'words'
      expect(root).to have_received(:add).with 'words'
    end

    it 'delegates `#add` to the root node' do
      container.add 'words'
      expect(root).to have_received(:add).with 'words'
    end

    it 'delegates `#each` to the root node' do
      container.each
      expect(root).to have_received :each
    end

    it 'delegates `#word?` to the root node' do
      container.word? 'words'
      expect(root).to have_received(:word?).with 'words'
    end

    it 'delegates `#partial_word?` to the root node' do
      container.partial_word? 'words'
      expect(root).to have_received(:partial_word?).with 'words'
    end

    it 'delegates `#compress!` to the root node' do
      container.compress!
      expect(root).to have_received :compress!
    end

    it 'delegates `#compressed?` to the root node' do
      container.compressed?
      expect(root).to have_received :compressed?
    end
  end
end