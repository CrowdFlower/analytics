module AnalyticsRuby
  def self.track_and_identify(event, properties, user, previous_id=nil)
    id = previous_id || user.id
    identify(:user_id => id, :traits => user.identity_payload)
    self.alias(:previous_id => previous_id, :user_id => user_id) if previous_id
    #Hubspot and others need an email address in the event...
    properties = {:email => user.email}.merge(properties)
    track(:user_id => user.id, :event => event, :properties => properties)
  end
end
