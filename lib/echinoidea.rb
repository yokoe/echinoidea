require "echinoidea/version"

module Echinoidea
  def self.project_root_directory?(path)
  	File.exists?([path, "Assets"].join("/"))
  end

  def self.editor_directory_path(root_directory_path)
  	[root_directory_path, "Assets", "Editor"].join("/")
  end

  def self.editor_directory_exists?(path)
  	File.exists?(self.editor_directory_path(path))
  end

  def self.create_editor_directory(path)
  	Dir::mkdir(self.editor_directory_path(path))
  end
end
