# frozen_string_literal: true

require 'jekyll'
require 'jekyll_plugin_logger'
require_relative '../lib/jekyll_quote'

Registers = Struct.new(:page, :site)

# Mock for Collections
class Collections
  def values
    []
  end
end

# Mock for Site
class SiteMock
  attr_reader :config

  def initialize
    @config = YAML.safe_load(File.read('_config.yml'))
  end

  def collections
    Collections.new
  end
end

# Mock for Liquid::ParseContent
class TestParseContext < Liquid::ParseContext
  attr_reader :line_number, :registers

  def initialize
    super
    @line_number = 123

    @registers = Registers.new(
      { 'path' => 'https://feeds.soundcloud.com/users/soundcloud:users:7143896/sounds.rss' },
      SiteMock.new
    )
  end
end

# Lets get this party started
class MyTest
  RSpec.describe Quote do
    let(:logger) do
      PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
    end

    let(:parse_context) { TestParseContext.new }

    let(:helper) do
      JekyllTagHelper.new(
        'quote',
        "cite='This is a citation' url='https://blah.com'",
        logger
      )
    end

    it 'is created properly' do
      quote = Quote.send(
        :new,
        'quote',
        "cite='This is a citation' url='https://blah.com'".dup,
        parse_context
      )
      result = quote.send(:render, parse_context)
      expect(result).to eq('')
    end
  end
end
