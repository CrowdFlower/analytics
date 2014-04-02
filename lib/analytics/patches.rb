module AnalyticsRuby
  def self.track_and_identify(event, properties, user)
    identify(:user_id => user.id, :traits => user.identity_payload)
    track(:user_id => user.id, :event => event, :properties => properties)
  end
end
