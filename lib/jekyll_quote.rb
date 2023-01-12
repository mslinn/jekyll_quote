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
  # Usage: {% quote [break] [by] [cite='Joe Blow'] [noprep] [url='https://blabla.com'] %}Bla bla.{% endquote %}
  # Output looks like:
  # <div class='quote'>
  #   Bla bla.
  #   <br><br> <span style='font-style:normal;'>&nbsp;&ndash; From Source cite.</span>
  # </div>
  class Quote < JekyllSupport::JekyllBlock
    attr_accessor :cite, :url

    def render_impl(text)
      @break  = @helper.parameter_specified? 'break' # enforced by CSS if a list ends the body
      @by     = @helper.parameter_specified? 'by'
      @cite   = @helper.parameter_specified? 'cite'
      @noprep = @helper.parameter_specified? 'noprep'
      @url    = @helper.parameter_specified? 'url'

      preposition = 'From'
      preposition = 'By' if @by
      preposition = '' if @noprep
      if @cite
        attribution = if @url && !@url.empty?
                        "<a href='#{@url}' rel='nofollow' target='_blank'>#{@cite}</a>"
                      else
                        "#{@cite}\n"
                      end
        tag = @break ? 'div' : 'span'
        attribution = "<#{tag} style='font-style:normal;'> &nbsp;&ndash; #{preposition} #{attribution}</#{tag}>\n"
        text = "<div>#{text}</div>" if @break
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
