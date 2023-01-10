# frozen_string_literal: true

require 'jekyll'
require_relative '../lib/jekyll_quote'

RSpec.describe(Jekyll) do
  include Jekyll

  let(:config) { instance_double('Configuration') }
  let(:context) {
    context_ = instance_double('Liquid::Context')
    context_.config = config
    context_
  }

  it 'is created properly' do
    # run_tag = RunTag.new('run', 'echo asdf')
    # output = run_tag.render(context)
    # expect(output).to eq('asdf')
  end
end
