module Analytics
  class Renderer
    include Helpers
    attr_reader :opts

    def initialize(template, opts = {})
      opts[:analytics_url] ||= Analytics.url
      opts[:global_options] ||= {}
      opts[:global_options][:exclude] = opts[:exclude] if opts[:exclude]
      @opts = OpenStruct.new(opts)
      @template = File.read(File.join(File.dirname(__FILE__), "../templates", template))
      @erubis = Erubis::Eruby.new(@template)
    end

    def render
      wrapper @erubis.result(binding)
    end
  end
end