class Reactions < Meth::Plugin

  class Reaction
  end

  def initialize *args
    super *args
    @bot.command_manager.register("reactions",self)
    @db = File.expand_path("#{DIST}/bots/#{$bot}/db/reactions.yaml")
    if File.exists?(@db) 
      unless @reactions = YAML.load_file(@db)
        @reactions = {}
      end
    else
      @bot.logger.warn "[ALIAS] #{@db} does not exist..."
      @reactions = {}
    end
  end

  def help(m=nil, topic=nil)
  end

  def command m
  end

  private

  def save
    file = File.open(@db,'w+')
    YAML.dump(@reactions,file)
    file.close
  end

end