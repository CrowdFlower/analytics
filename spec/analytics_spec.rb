require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Analytics" do
  before(:each) { Analytics.reset! }

  describe "header when initialized" do
    before(:each) { Analytics.init(:url => "//test.com") }

    it "renders header" do
      expect(Analytics.header({})).to match(/analytics\.load/)
    end

    it "renders url" do
      expect(Analytics.header({})).to match(/test\.com/)
    end

    it "renders key" do
      Analytics.init(:secret => "abcdefg")
      expect(Analytics.header({})).to match(/\/abcdefg\//)
    end
  
    it "renders intercom" do
      header = Analytics.header({:intercom_secret => "foo", :user_id => 1})
      expect(header).to match(/userHash: "/)
    end

    it "renders exluded modules" do
      header = Analytics.header({:exclude => ["Mixpanel"]})
      expect(header).to match(/exclude":\["Mix/)
    end

    it "hides olark if excluded" do
      header = Analytics.header({:exclude => ['Olark']})
      expect(header).to match(/olark\("api\.box\.hide"\)/)
    end

    it "renders olark" do
      header = Analytics.header({})
      expect(header).to_not match(/olark\("api\.box\.hide"\)/)
    end

    it "renders identify" do
      header = Analytics.header({:user_id => 1, :user_payload => {:name => "Frank"}})
      expect(header).to match(/analytics.identify\(1, \{/)
    end
  end

  describe "header when not initialized" do
    it "doesnt render" do
      expect(Analytics.header({})).to eq("")
    end
  end

  describe "initialized helpers" do
    before(:each) { Analytics.init(:url => "//test.com") }

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

  describe "non-initialized helpers" do
    it "identify" do
      expect(Analytics.identify(1,{rad:1})).to eq("")
    end

    it "track" do
      expect(Analytics.track("foo",{rad:1})).to eq("")
    end

    it "trackLink" do
      expect(Analytics.trackLink(".foo", "bar", {rad:1})).to eq("")
    end

    it "trackLink" do
      expect(Analytics.trackForm(".foo", "bar", {rad:1})).to eq("")
    end

    it "tracks with script tag" do
      expect(Analytics.track("foo",{rad:1}, {tag:true})).to match("")
    end
  end

  describe "server side" do
    it "doesnt blow up if not initialized" do
      expect(Analytics.ss.track(:user_id => 1, :event => "Shit")).to be_false
    end

    it "is initialized with secret" do
      Analytics.init(:secret => "abcdefg")
      expect(AnalyticsRuby.instance_variable_get(:@client)).to_not be_nil
    end

    it "isn't initialized without secret" do
      Analytics.init(:url => "//whatever")
      expect(AnalyticsRuby.instance_variable_get(:@client)).to be_nil
    end
  end

  describe "init" do
    it "sets url from secret" do
      Analytics.init(:secret => "abcdefg")
      expect(Analytics.url).to match(/\/abcdefg\//)
    end

    it "sets url from url" do
      Analytics.init(:url => "//whatever.com")
      expect(Analytics.url).to match(/\/whatever/)
    end
  end
end
