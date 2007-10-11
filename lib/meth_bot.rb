require "#{ROOT}/lib/irc"
class MethBot < Irc::Client

  @@server  = "irc.blitzed.org"

  def initialize *args
    # settings
    @nick     = "MethBot"
    @realname = "Meth Killer Bot 0.000001"
    @channels = ["#kahn"]
    # allways last
    # calls post_init
    super *args
  end

  def privmsg m
    handle_command(m) if m.command
  end

  def notice m
  end

  def handle_command m
    case m.command
    when "ping"
      m.reply "pong"
    when "hi"
      m.reply "Hey, Whats up!"
    when "ip"
      load 'plugins/ip.rb'
      ip = IPPlugin.new
      ip.privmsg(m)
      ip=nil
=begin
      case m.params[0]
      when "list"
        output = []
        users = @users.find(:all)
        users.each do |user|
          output << "#{user.nick} => #{user.ip}"
        end
        m.reply "#{users.length} users: #{output.join(', ')}"
      else # when "help"
        m.reply "ip list => Prints a list of users and their ip numbers..."
      end
=end
    else #when "help"
      m.reply "So far I only respond to: help, hi, ping, ip"
    end
  end

end

