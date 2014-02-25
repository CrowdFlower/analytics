require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Analytics" do
  describe "header" do
    it "renders header" do
      expect(Analytics.header({})).to match(/analytics\.load/)
    end

    it "defaults url" do
      expect(Analytics.header({})).to match(/djt0cz0t3xxdn/)
    end
  
    it "renders intercom" do
      header = Analytics.header({:intercom_secret => "foo", :user_id => 1})
      expect(header).to match(/userHash: "/)
    end

    it "renders olark" do
      header = Analytics.header({:include_olark? => true})
      expect(header).to match(/'Olark': true/)
    end

    it "renders identify" do
      header = Analytics.header({:user_id => 1, :user_payload => {:name => "Frank"}})
      expect(header).to match(/analytics.identify\(1, \{/)
    end
  end

  describe "helpers" do
    it "identify" do
      expect(Analytics.identify(1,{rad:1})).to eq("analytics.identify(1, {\"rad\":1}, _aopts);")
    end

    it "track" do
      expect(Analytics.track("foo",{rad:1})).to eq("analytics.track(\"foo\", {\"rad\":1}, _aopts);")
    end

    it "trackLink" do
      expect(Analytics.trackLink(".foo", "bar", {rad:1})).to eq("analytics.trackLink(jQuery(\".foo\"), \"bar\", {\"rad\":1}, _aopts);")
    end

    it "trackLink" do
      expect(Analytics.trackForm(".foo", "bar", {rad:1})).to eq("analytics.trackForm(jQuery(\".foo\"), \"bar\", {\"rad\":1}, _aopts);")
    end

    it "tracks with script tag" do
      expect(Analytics.track("foo",{rad:1}, {tag:true})).to match(/^<script.+analytics.track/m)
    end
  end
end
