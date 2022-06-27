# frozen_string_literal: true

require 'tempfile'
require 'English'
require 'puppetfile-resolver/util'
require 'puppetfile-resolver/spec_searchers/common'
require 'puppetfile-resolver/spec_searchers/git_configuration'
require 'puppetfile-resolver/util'
require 'uri'

module PuppetfileResolver
  module SpecSearchers
    module Git
      module GClone
        # @summary clones the remote url and reads the metadata file
        # @returns [String] the content of the metadata file
        def self.metadata(puppetfile_module, resolver_ui, config)
          repo_url = puppetfile_module.remote

          unless PuppetfileResolver::Util.git?
            resolver_ui.debug { 'Git executible not found, unable to use git clone resolution' }

            return nil
          end
          return nil if repo_url.nil?
          return nil unless valid_http_url?(repo_url)

          metadata_file = 'metadata.json'

          ref = puppetfile_module.ref ||
                puppetfile_module.tag ||
                puppetfile_module.commit ||
                puppetfile_module.branch ||
                'HEAD'

          resolver_ui.debug { "Querying git repository #{repo_url}" }

          clone_and_read_file(repo_url, ref, metadata_file, config)
        end

        # @summary clones the git url and reads the file at the given ref
        #          a temp directory will be created and then destroyed during
        #          the cloning and reading process
        # @param ref [String] the git ref, branch, commit, tag
        # @param file [String] the file you wish to read
        # @returns [String] the content of the file
        def self.clone_and_read_file(url, ref, file, config)
          clone_cmd = ['git', 'clone', '--bare', '--depth=1', '--single-branch']
          err_msg = ''
          if config.proxy
            err_msg += " with proxy #{config.proxy}: "
            proxy = "--config \"http.proxy=#{config.proxy}\" --config \"https.proxy=#{config.proxy}\""
            clone_cmd.push(proxy)
          end

          Dir.mktmpdir(nil, config.clone_dir) do |dir|
            clone_cmd.push("--branch=#{ref}") if ref != 'HEAD'
            clone_cmd.push(url, dir)
            out, err_out, process = ::PuppetfileResolver::Util.run_command(clone_cmd)
            err_msg += err_out
            raise err_msg unless process.success?
            Dir.chdir(dir) do
              content, err_out, process = ::PuppetfileResolver::Util.run_command(['git', 'show', "#{ref}:#{file}"])
              raise 'InvalidContent' unless process.success? && content.length > 2
              return content
            end
          end
        end

        def self.valid_http_url?(url)
          # uri does not work with git urls, return true
          return true if url.start_with?('git@')

          uri = URI.parse(url)
          uri.is_a?(URI::HTTP) && !uri.host.nil?
        rescue URI::InvalidURIError
          false
        end
      end
    end
  end
end
