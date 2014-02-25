module Analytics
  module Helpers
    def identify(user_id, payload)
      make_safe "analytics.identify(#{user_id.to_json}, #{payload.to_json}, _aopts);"
    end
    
    def track(event, properties, opts = {})
      selector = opts[:selector] ? "jQuery(\"#{opts[:selector]}\"), " : ""
      wrapper = opts[:tag] ? :javascript_tag : :raw
      make_safe self.send(wrapper, "analytics.track#{opts[:thing]}(#{selector}#{event.to_json}, #{properties.to_json}, _aopts);")
    end
    
    def trackLink(selector, event, properties, opts = {})
      make_safe track(event, properties, {thing: "Link", selector: selector}.merge(opts))
    end
    
    def trackForm(selector, event, properties, opts = {})
      make_safe track(event, properties, {thing: "Form", selector: selector}.merge(opts))
    end

    protected

    def make_safe(string)
      string.respond_to?(:html_safe) ? string.html_safe : string
    end

    def raw(stuff)
      stuff
    end

    def javascript_tag(stuff)
      <<-JS.strip
<script type="text/javascript">
#{stuff}
</script>
      JS
    end
  end
end