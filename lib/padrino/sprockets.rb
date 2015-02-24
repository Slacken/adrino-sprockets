# encoding: utf-8
require "sprockets"
require 'fileutils'
require 'yui/compressor'

module Padrino
  module Sprockets
    module Helpers
      module ClassMethods
        def sprockets(options={})
          url   = options[:url] || 'assets'
          _root = options[:root] || root
          paths = options[:paths] || []
          set :sprockets_url, url
          options[:root] = _root
          options[:url] = url
          options[:paths] = paths
          use Padrino::Sprockets::App, options
        end
      end

      module AssetTagHelpers
        # Change the folders to /assets/
        def asset_folder_name(kind)
          case kind
          when :css,:js,:images then 'assets'
          else kind.to_s
          end
        end
      end # AssetTagHelpers

      def self.included(base)
        base.send(:include, AssetTagHelpers)
        base.extend ClassMethods
      end
    end #Helpers

    class App
      attr_reader :assets

      def initialize(app, options={})
        @app = app
        @root = options[:root]
        @output = options[:output]
        url   =  options[:url] || 'assets'
        @matcher = /^\/#{url}\/*/
        setup_environment(options[:minify], options[:paths] || [])
      end

      def setup_environment(minify=false, extra_paths=[])
        @assets = ::Sprockets::Environment.new(@root)
        @assets.append_path 'assets/javascripts'
        @assets.append_path 'assets/stylesheets'

        if minify
          @assets.css_compressor = YUI::CssCompressor.new
          @assets.js_compressor = YUI::JavaScriptCompressor.new
        end

        extra_paths.each do |sprocket_path|
          @assets.append_path sprocket_path
        end
      end

      def precompile(bundles)
        output_dir = Pathname("#{@output}/assets")
        bundles.each do |file|
          tmp = file.to_s.split('/')
          prefix, basename = tmp[0...-1].join("/"), tmp[-1]
          path, dir = output_dir.join(prefix, basename), output_dir.join(prefix)
          FileUtils.mkpath(dir) unless Dir.exist?(dir)
          # clean up first
          File.delete(path) if File.exist?(path)
          # compile
          asset = @assets.find_asset(file)
          asset.write_to(path)
        end
      end

      def call(env)
        if @matcher =~ env["PATH_INFO"]
          env['PATH_INFO'].sub!(@matcher,'')
          @assets.call(env)
        else
          @app.call(env)
        end
      end
    end

    class << self
      def registered(app)
        app.helpers Padrino::Sprockets::Helpers
      end
    end
  end #Sprockets
end #Padrino
