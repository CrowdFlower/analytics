require 'openssl'
require 'json'
require 'ostruct'
require 'erubis'
require 'analytics-ruby'
require 'analytics/helpers'
require 'analytics/renderer'
require 'analytics/patches'

module Analytics
  extend Analytics::Helpers

  def self.url
    if options[:secret]
      "//d2dq2ahtl5zl1z.cloudfront.net/analytics.js/v1/#{options[:secret]}/analytics.min.js"
    else
      options[:url]
    end
  end

  def self.configure(options)
    @options = options
  end

  def self.options
    @options || {}
  end

  def self.init(option_override = nil)
    @options = option_override if option_override
    AnalyticsRuby.init(options) if options[:secret]
  end

  def self.header(opts)
    Renderer.new("header.js.erb", opts).render
  end

  def self.ss
    AnalyticsRuby
  end

  def self.reset!
    @options = nil
    AnalyticsRuby.instance_variable_set(:@client, nil)
  end
end
