require 'openssl'
require 'json'
require 'ostruct'
require 'erubis'
require 'analytics/helpers'
require 'analytics/renderer'

module Analytics
  extend Analytics::Helpers

  def self.header(opts)
    Renderer.new("header.js.erb", opts).render
  end
end