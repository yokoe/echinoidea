require 'echinoidea/version'

class Echinoidea::Builder
  attr_reader :class_name, :config, :file_path
  attr_accessor :build_target, :debug_mode, :development_mode, :loggings_enabled, :output_directory, :scenes

  def log(message)
    puts message if @loggings_enabled
  end

  def self.unique_builder_class_name
  	"ECBuilder#{Time.now.strftime('%y%m%d%H%M%S')}"
  end

  def initialize(root_directory, config, loggings_enabled = false)
    @class_name = self.class.unique_builder_class_name
    @root_directory = root_directory
    @config = config
    @build_target = "iPhone" # Default build target
    @debug_mode = false
    @loggings_enabled = true if loggings_enabled == true
    @development_mode = false

    log "Initializing builder"
    log "  root_directory: #{root_directory}"
    log "  config: #{config}"
  end

  def file_path
    [@root_directory, "Assets", "Editor", "#{@class_name}.cs"].join("/").gsub(" ", " ")
  end

  def write_to_file
    log "Write a batch build script to: #{self.file_path}"
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

      build_opts = @build_target == "iPhone" ? "BuildOptions.SymlinkLibraries" : "BuildOptions.None"
      build_opts = "BuildOptions.SymlinkLibraries | BuildOptions.Development | BuildOptions.AllowDebugging" if @development_mode == true

      log "  class_name: #{@class_name}"
      log "  build_opts: #{build_opts}"
      log "  scenes: #{scenes}"
      log "  output_directory: #{output_directory}"
      log "  build_target: #{@build_target}"

      f.write "using UnityEngine;
using UnityEditor;
using System.Collections;
public class #{@class_name}
{
  public static void Build()
  {
    #{player_settings_opts_string}
    BuildOptions opt = #{build_opts};

    string[] scenes = {#{scenes}};
    BuildPipeline.BuildPlayer(scenes, \"#{@output_directory}\", BuildTarget.#{@build_target}, opt);
    EditorApplication.Exit(0);
  }
}"
    }
  end
  def remove_files
    File.delete(self.file_path)
    begin
      File.delete("#{self.file_path}.meta")
    rescue
      puts "Failed to delete meta file. #{self.file_path}.meta"
    end
  end

  def run_unity_command
    opts = debug_mode ? "" : "-quit -batchMode"
    project_path = @root_directory.gsub(" ", "\\ ")
    command = "/Applications/Unity/Unity.app/Contents/MacOS/Unity #{opts} -executeMethod #{@class_name}.Build -projectPath #{project_path}"
    log "Running unity.app..."
    log "  #{command}"
    `#{command}`
  end

  def run
    write_to_file
    run_unity_command
    remove_files
  end
end