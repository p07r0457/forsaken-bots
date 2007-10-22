require 'yaml'
class LinksPlugin < Meth::Plugin
  def initialize *args
    super *args
    @db = "#{DIST}/bots/#{$config_file}/db/links.yaml"
  end
  def links
    data = YAML.load_file(@db) if File.exists?(@db)
    data ? data : {}
  end
  def delete name
    data = links
    data.delete(name)
    save data
  end
  def save data
    f = File.open(@db,'w+')
    YAML.dump(data,f)
    f.close
  end
  def add(name, url)
    data = links
    data[name] = url
    save data
  end
end