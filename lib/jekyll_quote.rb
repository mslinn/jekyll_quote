# frozen_string_literal: true

require 'jekyll_plugin_support'
require 'jekyll_plugin_support_helper'
require_relative 'jekyll_quote/version'

# @author Copyright 2022 Michael Slinn
# @license SPDX-License-Identifier: Apache-2.0

module QuoteModule
  PLUGIN_NAME = 'quote'
end

module Jekyll
  # Usage: {% quote cite='Joe Blow' url='https://blabla.com' %}Bla bla.{% endquote %}
  # Output looks like:
  # <div class='quote'>
  #   Bla bla.
  #   <br><br> <span style='font-style:normal;'>&nbsp;&ndash; From Source cite.</span>
  # </div>
  class Quote < JekyllSupport::JekyllBlock
    attr_accessor :cite, :url

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

      @cite = @helper.parameter_specified?('cite')
      @url = @helper.parameter_specified?('url')
    end

    def render_impl(text)
      text.strip!
      if @cite
        attribution = if @url && !@url.empty?
                        "<a href='#{@url}' rel='nofollow' target='_blank'>#{@cite}</a>"
                      else
                        "#{@cite}\n"
                      end
        attribution += "\n<br><br>" if text.end_with?('</ol>') || text.end_with?('</ul>')
        attribution = "<span style='font-style:normal;'> &nbsp;&ndash; From #{@attribution}</span>\n"
      end
      <<~END_HERE
        <div class='quote'>
          #{text}#{attribution}
        </div>
      END_HERE
    end
  end
end

PluginMetaLogger.instance.info { "Loaded #{QuoteModule::PLUGIN_NAME} v0.1.0 plugin." }
Liquid::Template.register_tag(QuoteModule::PLUGIN_NAME, Jekyll::Quote)
