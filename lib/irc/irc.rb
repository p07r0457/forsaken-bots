module Irc
end

# manages users
require 'irc/user'

# handles a message
require 'irc/handle_message'

# master message class
require 'irc/message' # super class

# message types
require 'irc/privmsg_message'
require 'irc/join_message'
require 'irc/part_message'
require 'irc/quit_message'
require 'irc/notice_message'
require 'irc/unknown_message'

# the actual client
require 'irc/client'
