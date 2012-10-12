require 'echinoidea/version'

class Echinoidea::Builder
  attr_reader :class_name, :config, :file_path
  attr_accessor :build_target, :output_directory, :scenes

  def self.unique_builder_class_name
  	"ECBuilder#{Time.now.strftime('%y%m%d%H%M%S')}"
  end

  def initialize(root_directory, config)
    @class_name = self.class.unique_builder_class_name
    @root_directory = root_directory
    @config = config
    @build_target = "iPhone" # Default build target
  end

  def file_path
    [@root_directory, "Assets", "Editor", "#{@class_name}.cs"].join("/")
  end

  def write_to_file
    # Thanks to: http://ameblo.jp/principia-ca/entry-11010391965.html
    File.open(self.file_path,'w'){|f|
      scenes = @config['scenes'].map{|scene| "\"#{scene}\""}.join(",")

      player_settings_opts = {}

      if @config['bundle_identifier']
        bundle_identifier = @config['bundle_identifier']
        player_settings_opts["bundleIdentifier"] = "\"#{bundle_identifier}\""
      end

      if @config['stripping_level']
        player_settings_opts["strippingLevel"] = "StrippingLevel.#{@config['stripping_level']}"
      end
      if @config['api_compatibility_level']
        player_settings_opts["apiCompatibilityLevel"] = "ApiCompatibilityLevel.#{@config['api_compatibility_level']}"
      end

      player_settings_opts_string = player_settings_opts.map{|k,v| "PlayerSettings.#{k} = #{v};"}.join("\n")

      f.write "using UnityEngine;
using UnityEditor;
using System.Collections;
public class #{@class_name}
{
  public static void Build()
  {
    #{player_settings_opts_string}
    BuildOptions opt = BuildOptions.SymlinkLibraries;

    string[] scenes = {#{scenes}};
    BuildPipeline.BuildPlayer(scenes, \"#{@output_directory}\", BuildTarget.#{@build_target}, opt);
    EditorApplication.Exit(0);
  }
}"
    }
  end
  def remove_files
    File.delete(self.file_path)
    File.delete("#{self.file_path}.meta")
  end

  def run_unity_command
    `/Applications/Unity/Unity.app/Contents/MacOS/Unity -quit -batchMode -executeMethod #{@class_name}.Build -projectPath #{@root_directory}`
  end

  def run
    write_to_file
    run_unity_command
    remove_files
  end
end