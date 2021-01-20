# Analytics

Analytics provides helpers for using segment.io in Rails and ... wait for it ... MERB :(  It supports both a custom build of the opensource segment.io project or using the paid service.  If the paid service is used, this also provides the ruby serverside gem.

## Usage

```ruby
gem 'analytics', git: "git://github.com/CrowdFlower/analytics.git"
```

You must call `Analytics.init` for any of the helpers to return anything.  Generally it's a good idea to only call Analytics.init in your production environment, this way way you don't track testing or development events.  If you're running unicorn, you'll need to call it in an `after_fork` block.  To facilitate configuration, we also provide an `Analytics.configure` method that can be called in an initializer which will allow you to call `Analytics.init` without any params in `unicorn.rb`.  You can also access the options set by configure by calling `Analytics.options`.

```ruby
Analytics.init(:secret => "abcdefg") #Uses the paid version of segment.io
Analytics.init(:url => "//something.cloudfront.com/custom_build.js.gz") #Uses your own custom build of segment.io

Analytics.configure(:secret => "abcdefg", :intercom_secret => "A2c4e0B1...") #In an initializer
Analytics.init #In unicorn.rb
Analytics.options[:intercom_secret] #Wherever you need secrets
```

Now in the header of your application:

```ruby
<%= Analytics.header(
  user_id: 1,
  user_payload: {
    email: "foo@bar.com",
    name: "Foo Bar",
    plan: "basic",
    created: "2014 10 22 12:23:14",
    balance: "90.32"
  },
  exclude: ['Olark'],
  intercom_secret: "A2c4e0B1..."
) %>
```

The important options are in the sample payload above.  If a user isn't logged in, don't provide the `user_id` or `user_payload`.  If you need to disable an integration, specify it in the `exclude` array.  If you're using intercom, you can provide the `intercom_secret`.

And anywhere in your application you can call track:

```ruby
<%= Analytics.track("something", {some_property: "rad"}, {tag: true}) %>
```

This will generate the proper javascript within a script tag.  If you're already in a script tag when you call it you can omit `tag: true`.

You can also call `trackForm` or `trackLink` and pass in a selector as the first parameter, this assumes you have jQuery available on the page.

## Serverside tracking

If the Analytics is initialized with `:secret => "something"` the [analytics-ruby gem](https://github.com/segmentio/analytics-ruby) is initialized and exposed via `Analytics.ss`.

```ruby
Analytics.ss.track(:event => "Spent Money", :user_id => 32, :properties => {:revenue => 300})
```

If `Analytics.init` was never called, all calls to `Analytics.ss.whatever` will return false.

## Custom build of segment.io/analytics.js

You can make a custom build of segment.io's javascript library, however it's a pain in the ass and you can use serverside tracking.

1. Fork https://github.com/segmentio/analytics.js
2. Fork https://github.com/segmentio/analytics.js-integrations
3. Modify index.js in the forked integrations repo to include only the integrations you need, i.e.:
  ```ruby
  var integrations = ["adwords","google-analytics","hubspot","intercom","mixpanel","olark","optimizely","rollbar"];
  ```
4. Modify the scripts portion of component.json in the integrations repo to only include the integrations you need.
5. Modify component.json of the analytics.js repo to point to the master branch of your forked integrations repo: i.e.
  "CrowdFlower/analytics.js-integrations": "master"
6. Push your changes to github.
7. Run `make` from the analytics.js repo
8. To enable async loading replace the following at the end of the analytics.js:
  ```js
  if (typeof exports == "object") {
    module.exports = require("analytics");
  } else if (typeof define == "function" && define.amd) {
    define([], function(){ return require("analytics"); });
  } else {
    this["analytics"] = require("analytics");
  }
  ```
  With the following:

  ```js
  var analytics =  require("analytics");

  analytics.initialize({
    'Google Analytics': {
      trackingId: 'UA-3841988-12',
      domain: 'crowdflower.com',
      ignoreReferrer: 'crowdflower.com'
    },
    'Mixpanel': {
      token: '6391ff7ebb759bbb796f8a74d9229e68',
      people: true
    },
    'HubSpot': {
      portalId:'346378'
    },
    'Intercom': {
      appId: '900ddb390526bf805ee5f5b18b44b1bded27420d'
    }
  })

  //Replay any queued analytics calls
  while (window.analytics && window.analytics.length > 0) {
    var args = window.analytics.shift();
    var method = args.shift();
    if (analytics[method]) analytics[method].apply(analytics, args);
  }
  window.analytics = analytics;
  ```
9. Minify your new analytics.js and gzip.
10. Throw it into S3, set the Content-Type to `application/x-javascript` and the Content-Encoding to `gzip`
11. Put cloudfront in front of it for extra awesome.

## Contributing to analytics

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Application list with `analytics` gem:
* [Builder](https://github.com/CrowdFlower/CrowdFlower/blob/b5fe12140eb09906225e141eafe08a9a436c2aa6/projects/builder/Gemfile#L105)
* [Make](https://github.com/CrowdFlower/CrowdFlower/blob/b5fe12140eb09906225e141eafe08a9a436c2aa6/projects/make/Gemfile#L128)

## Copyright

Copyright (c) 2014 Chris Van Pelt. See LICENSE.txt for
further details.
