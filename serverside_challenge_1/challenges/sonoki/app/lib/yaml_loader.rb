module YamlLoader
  def yaml_data
    require 'yaml'
    @yaml_data ||= YAML.load_file(Rails.root.join('config', 'rates.yml'))
  end
end
