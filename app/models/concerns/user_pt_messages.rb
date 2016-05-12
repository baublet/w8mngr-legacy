require 'active_support/concern'

module UserPtMessages
  extend ActiveSupport::Concern
  # Saves an array of messages to the PT_Messages table, but only if they don't
  # have an active type of that message remaining and only if the user doesn't
  # have a message of that type with the exact same UID already in the DB
  #
  # Params:
  # +messages+:: An array of hashes with the sub-elements +type+, +uid+, and +message+
  def save_pt_messages messages
    return false if messages.nil?
    return false unless messages.count > 0
    # First, load all messages matching the type passed in messages
    types = []
    messages.each do |message|
      types << message[:type]
    end

    # Get the user's last message types that we need to update from the DB
    user_messages = self.pt_messages.where(deleted: false, message_type: types)

    messages.each do |message|
      # First, find the messages[:type] that matches the message[:type]
      to_insert = user_messages.each do |msg|
        return msg if msg.message_type = message[:type]
      end
      # If they match UID's, don't do anything
      if defined? to_insert.uid
        next unless to_insert.uid != message[:uid]
        # The UID's don't match, but the user has this message type in their stack,
        # so let's update its values to be our new UID and message
        to_insert.update_attributes(uid: message[:uid], message: message[:message])
      else
        # The user doesn't have a message of this type, so let's create one
        self.pt_messages.build(message_type: message[:type], uid: message[:uid], message: message[:message]).save
      end
    end
    return true
  end

  # Loads messages of a single type into an array and marks them as read. This method
  # should only be used in controllers or views!
  #
  # Params:
  # +type+:: Either a string or an array of types of messages to load
  def get_pt_messages_of_type type
    # We turn this into an array because otherwise it would return an ActiveRecord::ActiveRelation
    # that automagically updates the links that we're about to update, and since it maintains
    # the relation of seen:false, when we change it to seen:true below, this would return an
    # empty number of ActiveRelations!
    user_messages = self.pt_messages.where(deleted: false, seen: false, message_type: type).to_a
    # Now mark them all as read
    self.pt_messages.where(deleted: false, seen: false, message_type: type).update_all(seen: true)
    return user_messages
  end

  # Loads all of the user's PT messages into an array and marks them as read. Again,
  # this method only should be used in views and controllers
  def get_pt_messages
    # We turn this into an array because otherwise it would return an ActiveRecord::ActiveRelation
    # that automagically updates the links that we're about to update, and since it maintains
    # the relation of seen:false, when we change it to seen:true below, this would return an
    # empty number of ActiveRelations!
    user_messages = self.pt_messages.where(deleted: false, seen: false).to_a
    # Now mark them all as read
    self.pt_messages.where(deleted: false, seen: false).update_all(seen: true)
    return user_messages
  end

  # Loads the most recent PT message for the user and marks it as read.
  #
  # Params:
  # +for_sending+:: If true, this method will ignore messages that the user has
  # marked to NOT receive updates for.
  def get_latest_pt_message for_sending = false

    # TODO: ignore those marked as to ignore if these are meant for sending

    user_message = self.pt_messages.where(deleted: false, seen: false).last
    return nil if user_message.nil?
    # Mark it as read
    self.pt_messages.where(deleted: false, seen: false).last.update_attribute(:seen, true)
    return user_message
  end

  # Loads a random unseet PT message for the user and marks it as read
  #
  # Params:
  # +for_sending+:: If true, this method will ignore messages that the user has
  # marked to NOT receive updates for.
  def get_random_pt_message for_sending = false

    # TODO: ignore those marked as to ignore if these are meant for sending

    user_message = self.pt_messages.where(deleted: false, seen: false).order("RANDOM()").first
    return nil if user_message.nil?
    # Mark it as read
    user_message.seen = true
    user_message.save
    return user_message
  end
end