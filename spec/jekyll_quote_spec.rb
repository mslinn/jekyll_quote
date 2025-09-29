require 'jekyll'
require 'jekyll_plugin_logger'
require 'rspec/match_ignoring_whitespace'
require_relative 'spec_helper'

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

# FIXME: These tests all fail because I have not figured out how to provide a Jekyll block body to a test
class MyTest
  RSpec.describe Jekyll::Quote do
    let(:logger) do
      PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
    end

    let(:parse_context) { TestParseContext.new }

    let(:helper) do
      JekyllSupport::JekyllPluginHelper.new(
        'quote',
        'This is a quote.',
        logger
      )
    end

    it 'has no cite or url', skip: 'unfinished' do
      helper.reinitialize('Quote has no cite or url.')
      quote = described_class.send(
        :new,
        'quote',
        helper.markup.dup,
        logger
      )
      result = quote.send(:render_impl, helper.markup)
      expect(result).to match_ignoring_whitespace <<-END_RESULT
        <div class='quote'>
          Quote has no cite or url.
        </div>
      END_RESULT
    end

    it 'has a cite but no url', skip: 'unfinished' do
      helper.reinitialize("cite='This is a citation' The quote has a cite but no url.")
      quote = described_class.send(
        :new,
        'quote',
        helper.markup.dup,
        logger
      )
      result = quote.send(:render_impl, helper.markup)
      expect(result).to match_ignoring_whitespace <<-END_RESULT
        <div class='quote'>
          This is the quoted text.
          <br><br>
          <span style='font-style:normal;'> &nbsp;&ndash; From This is a citation </span>
        </div>
      END_RESULT
    end

    it 'has a url but no cite', skip: 'unfinished' do
      helper.reinitialize("url='https://blah.com' The quote has a url but no cite.")
      quote = described_class.send(
        :new,
        'quote',
        helper.markup.dup,
        logger
      )
      result = quote.send(:render_impl, helper.markup)
      expect(result).to match_ignoring_whitespace <<-END_RESULT
        <div class='quote'>
        The quote has a url but no cite.
        </div>
      END_RESULT
    end

    it 'has a cite and a url', skip: 'unfinished' do
      helper.reinitialize "cite='This is a citation' url='https://blah.com' The quote has a url and a cite.".+
      quote = described_class.send(
        :new,
        'quote',
        helper.markup.dup,
        logger
      )
      result = quote.send(:render_impl, helper.markup)
      expect(result).to match_ignoring_whitespace <<-END_RESULT
        <div class='quote'>
        The quote has a url but no cite.
          <br><br>
          <span style='font-style:normal;'> &nbsp;&ndash; From
            <a href='https://blah.com' rel='nofollow' target='_blank'>This is a citation.</a>
          </span>
        </div>
      END_RESULT
    end
  end
end
