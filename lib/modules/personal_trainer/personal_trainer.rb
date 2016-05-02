module PersonalTrainer
  # This is a module intended to give encouragement, track a person's goals
  # and remind users to fill in certain bits of information. I'm coding it as
  # a separate module because I want it to be able to be run in several points
  # of the application -- in APIs, in ActiveJobs, and on the FrontEnd. Like
  # Clippy, I also want it to be able to be turned off ;)
  #
  # Spec
  #
  # This module and its children are called at certain points by controllers
  # with some specific data passed into it, including some options. The module
  # then massages the data, figures out which messages to return, then returns
  # an array of messages (sometimes only one) in the following form:
  #
  # messages = [
  #              {  text: "Message",
  #                 type: "message-type-identifier",
  #                 uid:  "message-unique-id"
  #              }
  # ]
  #
  # The message types are intended to be unique. That is, a user can only have
  # one outstanding message of a given type at a time. It's up to our Messages
  # model to figure out what to do with the return values from this module,
  # but presume that uids will always be unique! This means that you might, for
  # example, have a message type that already exists, but the unique ID is
  # different, indicating that a different message came back of the same type.
  # In this case, you would want to kill the old one and insert this new one.
  #
  # To use a concrete example, this might mean that a message letting the user
  # know that they haven't entered any entries today might be duplicated for
  # the next day, but the message would be different (saying, e.g., that they
  # haven't entered any information for two straight days), so we would nuke
  # the old message and insert this new one for the user.
end