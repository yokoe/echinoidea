require 'echinoidea/version'

class Echinoidea::Builder
  attr_reader :class_name, :file_path

  def self.unique_builder_class_name
  	"ECBuilder#{Time.now.strftime('%y%m%d%H%M%S')}"
  end

  def initialize(root_directory)
    @class_name = self.class.unique_builder_class_name
    @root_directory = root_directory
  end

  def file_path
    [@root_directory, "Assets", "Editor", "#{@class_name}.cs"].join("/")
  end

  def write_to_file
    File.open(self.file_path,'w'){|f|
     f.write "Hello Builder"
    }
  end
  def remove_file
    File.delete(self.file_path)
  end
end