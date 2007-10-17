load "#{DIST}/lib/direct_play.rb"
class Ip < Meth::Plugin

  #@@reload = true

  include DirectPlay

  def command m
    # test topic
    case m.params.shift
    when "list"
      list m
    when "hosting"
      is_hosting? m
    else # default help
      m.reply help(m)
    end
  end

  def help m=nil,topic=nil
    case topic||m.params.shift||""
      when "list"
        "ip list [[pattern]...] => Gets a user[s] ip address. "+
        "(optional) [[pattern]..] patterns seperated by space to search for user names. "+
        "Leave blank to get all addresses."
      when "hosting"
        "ip hosting <ip> => Check if an ip is hosting..."
      when "scan"
        "ip scan [[pattern]...] => Queries a user to see if they are hosting/playing. "+
        "[[pattern]...] patterns seperated by a space to search for user names."
      else
        "ip [command] => ip address tools. "+
        "[command] can be one of: list, scan, hosting"
    end
  end

  def is_hosting? m
    ip = m.params.shift
    unless ip
      m.reply "Missing <ip> argument."
      return
    end
    hosting?(ip,
             Proc.new { |time| m.reply "#{ip} is hosting..."     },
             Proc.new { |time| m.reply "#{ip} is NOT hosting..." })
  end

  # get ip of user
  def list m

    #
    targets = m.params

    # output holder
    list = []

    # get and format list of found addresses
    Irc::User.filter(@bot.users,targets).each do |user|
      list << "#{user.nick} => #{user.ip}"
    end

    list = list.join(', ')

    # send the answer
    if m.personal || targets.length>0
      m.reply list
    else
      m.reply "A full list of ip numbers from #{m.channel.name} has been messaged to you. "+
              "To print the message here you have to specify a search pattern. "+
              "For more info type 'ip help'"
      m.reply_directly list
    end

  end

end
