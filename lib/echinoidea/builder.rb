require 'echinoidea/version'

class Echinoidea::Builder
  attr_reader :class_name, :file_path
  attr_accessor :scenes, :output_directory

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
      scenes = @scenes.map{|scene| "\"#{scene}\""}.join(",")
      f.write "using UnityEngine;
using UnityEditor;
using System.Collections;
public class #{@class_name}
{
  private static string[] scene = {#{scenes}};
  public static void Build()
  {
    BuildOptions opt = BuildOptions.SymlinkLibraries;
    /*string errorMsg = */BuildPipeline.BuildPlayer(scene, \"#{@output_directory}\", BuildTarget.iPhone,opt);
    EditorApplication.Exit(0);
  }
}"
    }
  end
  def remove_file
    File.delete(self.file_path)
    File.delete("#{self.file_path}.meta")
  end

  def run_unity_command
    `/Applications/Unity/Unity.app/Contents/MacOS/Unity -quit -batchmode -executeMethod #{@class_name}.Build -projectPath #{@root_directory}`
  end
end