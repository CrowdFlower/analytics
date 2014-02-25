module Analytics
  class Renderer
    include Helpers
    attr_reader :opts

    def initialize(template, opts = {})
      opts[:analytics_url] ||= "//djt0cz0t3xxdn.cloudfront.net/analytics.min.js.gz"
      @opts = OpenStruct.new(opts)
      @template = File.read(File.join(File.dirname(__FILE__), "../templates", template))
      @erubis = Erubis::Eruby.new(@template)
    end

    def render
      @erubis.result(binding)
    end
  end
end