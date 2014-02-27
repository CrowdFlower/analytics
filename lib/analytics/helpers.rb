module Analytics
  module Helpers
    def identify(user_id, payload)
      wrapper "analytics.identify(#{user_id.to_json}, #{payload.to_json}, _aopts);"
    end
    
    def track(event, properties, opts = {})
      selector = opts[:selector] ? "jQuery(\"#{opts[:selector]}\"), " : ""
      wrapper = opts[:tag] ? :javascript_tag : :raw
      wrapper self.send(wrapper, "analytics.track#{opts[:thing]}(#{selector}#{event.to_json}, #{properties.to_json}, _aopts);")
    end
    
    def trackLink(selector, event, properties, opts = {})
      wrapper track(event, properties, {thing: "Link", selector: selector}.merge(opts))
    end
    
    def trackForm(selector, event, properties, opts = {})
      wrapper track(event, properties, {thing: "Form", selector: selector}.merge(opts))
    end

    protected

    def wrapper(string)
      if Analytics.url
        string.respond_to?(:html_safe) ? string.html_safe : string
      else
        ""
      end
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