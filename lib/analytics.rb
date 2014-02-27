require 'openssl'
require 'json'
require 'ostruct'
require 'erubis'
require 'analytics-ruby'
require 'analytics/helpers'
require 'analytics/renderer'

module Analytics
  extend Analytics::Helpers

  def self.url
    if @key
      "//d2dq2ahtl5zl1z.cloudfront.net/analytics.js/v1/#{@key}/analytics.min.js"
    else
      @url
    end
  end

  def self.init(options = {})
    @key = options[:secret]
    @url = options.delete(:url)
    AnalyticsRuby.init(options) if @key
  end

  def self.header(opts)
    Renderer.new("header.js.erb", opts).render
  end

  def self.ss
    AnalyticsRuby
  end

  def self.reset!
    @key = nil
    @url = nil
    AnalyticsRuby.instance_variable_set(:@client, nil)
  end
end