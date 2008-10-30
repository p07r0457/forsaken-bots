class Irc::KickMessage < Irc::Message
  attr_accessor :admin, :user, :channel, :message
  def initialize(client,line,time)
    super(client,line,time)

    # :methods!n=daquino@c-68-36-237-152.hsd1.nj.comcast.net
    # KICK #forsaken DIII-The_Lion :methods
    unless line =~ /:([^ ]*)![^@]*@[^ ]* KICK (#[^ ]*) ([^ ]*) *:*([^\n]*)/i
      puts "Bad Kick message..."
      return
    end

    kicker   = $1
    channel = $2
    kicked   = $3
    @message = $4
 
    @channel = @client.channels[channel.downcase]

    unless @admin = Irc::User.find(kicker)
      puts "[KICK] Kicker was not found..."
    end

    unless @user = Irc::User.find(kicked)
      puts "[KICK] Kicked was not found..."
    else
      @user.destroy
    end

  end
end
