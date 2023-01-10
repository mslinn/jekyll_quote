# frozen_string_literal: true

require 'jekyll'
require 'jekyll_plugin_logger'
require 'key_value_parser'
require 'shellwords'
require_relative 'jekyll_quote/version'

# @author Copyright 2022 Michael Slinn
# @license SPDX-License-Identifier: Apache-2.0
module JekyllPluginQuote
  PLUGIN_NAME = 'quote'
end

module Jekyll
  # Usage: {% quote cite='Joe Blow' url='https://blabla.com' %}Bla bla.{% endquote %}
  # Output looks like:
  # <div class='quote'>
  #   Bla bla.
  #   <br><br> <span style='font-style:normal;'>&nbsp;&ndash; From Source cite.</span>
  # </div>
  class Quote < Liquid::Block
    # See https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers#create-your-own-tags
    # @param tag_name [String] the name of the tag, which we already know.
    # @param argument_string [String] the arguments from the tag, as a single string.
    # @param parse_context [Liquid::ParseContext] hash that stores Liquid options.
    #        By default it has two keys: :locale and :line_numbers, the first is a Liquid::I18n object, and the second,
    #        a boolean parameter that determines if error messages should display the line number the error occurred.
    #        This argument is used mostly to display localized error messages on Liquid built-in Tags and Filters.
    #        See https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers#create-your-own-tags
    # @return [void]
    def initialize(tag_name, argument_string, parse_context) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      super
      @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
      @argument_string = argument_string

      argv = Shellwords.split(argument_string) # Scans name/value arguments
      params = KeyValueParser.new.parse(argv) # Extracts key/value pairs, default value for non-existant keys is nil

      @cite = params[:cite]
      url = ''
      argv.each do |arg|
        if arg.start_with?('url=')
          url = arg.delete_prefix('url=')
          _ = params[:url]
        end
      end
      @cite = "<a href='#{url}' rel='nofollow' target='_blank'>#{@cite}</a>" if @cite && url && !url.empty?
    end

    # Method prescribed by the Jekyll plugin lifecycle.
    # @return [String]
    def render(context)
      text = super
      @cite = "#{@cite}\n<br><br>\n" unless text.end_with?('</ol>') || text.end_with?('</ul>')
      @cite = "<span style='font-style:normal;'> &nbsp;&ndash; From #{@cite}</span>\n" if @cite
      <<~END_HERE
        <div class='quote'>
          #{text}#{@cite}
        </div>
      END_HERE
    end
  end
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginQuote::PLUGIN_NAME} v0.1.0 plugin." }
Liquid::Template.register_tag(JekyllPluginQuote::PLUGIN_NAME, QuoteModule::Quote)
