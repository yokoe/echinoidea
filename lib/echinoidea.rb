require "echinoidea/version"

module Echinoidea
  def self.project_root_directory?(path)
  	File.exists?([path, "Assets"].join("/"))
  end
end
