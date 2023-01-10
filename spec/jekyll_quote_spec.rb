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
  RSpec.describe Jekyll::Quote do # rubocop:disable Metrics/BlockLength
    let(:logger) do
      PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
    end

    let(:parse_context) { TestParseContext.new }

    let(:helper) do
      JekyllTagHelper.new(
        'quote',
        "cite='This is a citation' url='https://blah.com' This is the quoted text.",
        logger
      )
    end

    it 'is created properly' do
      command_line = "cite='This is a citation' url='https://blah.com' This is the quoted text.".dup
      quote = Jekyll::Quote.send(
        :new,
        'quote',
        command_line,
        parse_context
      )
      result = quote.send(:render_impl, command_line)
      expect(result).to match_ignoring_whitespace <<-END_RESULT
        <div class='quote'>
          This is the quoted text.
          <br><br>
          <span style='font-style:normal;'> &nbsp;&ndash; From <a href='https://blah.com' rel='nofollow' target='_blank'>This is a citation</a>
          </span>
        </div>
      END_RESULT
    end
  end
end
