module AnalyticsRuby
  def self.track_and_identify(event, properties, user)
    identify(:user_id => user.id, :traits => user.identity_payload)
    #Hubspot and others need an email address in the event...
    properties = {:email => user.email}.merge(properties)
    track(:user_id => user.id, :event => event, :properties => properties)
  end
end
