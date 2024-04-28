require 'jekyll_plugin_support'
require 'helper/jekyll_plugin_helper'
require_relative 'jekyll_quote/version'

# @author Copyright 2022 Michael Slinn
# @license SPDX-License-Identifier: Apache-2.0

module QuoteModule
  PLUGIN_NAME = 'quote'.freeze
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

    include JekyllQuoteVersion

    def render_impl(text)
      @helper.gem_file __FILE__ # This enables plugin attribution

      @break  = @helper.parameter_specified? 'break' # enforced by CSS if a list ends the body
      @by     = @helper.parameter_specified? 'by'
      @cite   = @helper.parameter_specified? 'cite'
      @class  = @helper.parameter_specified? 'class'
      @noprep = @helper.parameter_specified? 'noprep'
      @style  = @helper.parameter_specified? 'style'
      @url    = @helper.parameter_specified? 'url'
      preposition = 'From'
      preposition = 'By' if @by
      preposition = '' if @noprep
      if @cite
        cite_markup = if @url && !@url.empty?
                        "<a href='#{@url}' rel='nofollow' target='_blank'>#{@cite}</a>"
                      else
                        "#{@cite}\n"
                      end
        tag = @break ? 'div' : 'span'
        @cite_markup = "<#{tag} class='quoteAttribution'> &nbsp;&ndash; #{preposition} #{cite_markup}</#{tag}>\n"
      end
      @text = @break ? "<div class='quoteText clearfix'>#{text}</div>" : text
      output
    end

    def output
      klass = "#{@class} " if @class
      styling = " style='#{@style}'" if @style
      <<~END_HERE
        <div class='#{klass}quote'#{styling}>
          #{@text}#{@cite_markup}
          #{@helper.attribute if @helper.attribution}
        </div>
      END_HERE
    end

    JekyllPluginHelper.register(self, QuoteModule::PLUGIN_NAME)
  end
end
