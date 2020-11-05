# frozen_string_literal: true

module PuppetfileResolver
  module Util
    PROXY_ENVVARS = if File::ALT_SEPARATOR
                      %w[https_proxy http_proxy].freeze
                    else
                      %w[HTTPS_PROXY HTTP_PROXY https_proxy http_proxy].freeze
                    end

    def self.symbolise_object(object)
      case # rubocop:disable Style/EmptyCaseCondition Ignore
      when object.is_a?(Hash)
        object.inject({}) do |memo, (k, v)| # rubocop:disable Style/EachWithObject Ignore
          memo[k.to_sym] = symbolise_object(v)
          memo
        end
      when object.is_a?(Array)
        object.map { |i| symbolise_object(i) }
      else
        object
      end
    end

    def self.static_ca_cert_file
      @static_ca_cert_file ||= File.expand_path(File.join(__dir__, 'data', 'ruby_ca_certs.pem'))
    end

    # Executes the block with the given proxy set in ENV.
    def self.with_proxy_envvars(new_proxy)
      unless new_proxy.nil?
        old_proxy = Hash[PROXY_ENVVARS.collect { |var| [var, ENV[var]] }]
        old_proxy.each_key { |var| ENV[var] = new_proxy }
      end

      begin
        yield
      ensure
        ENV.update(old_proxy) if old_proxy
      end

      nil
    end
  end
end
