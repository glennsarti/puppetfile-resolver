# frozen_string_literal: true
require 'rubygems'
require 'bundler'
require 'bundler/gem_tasks'
require 'rake/testtask'

begin
  Bundler.setup(:default, :development, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task default: :spec

namespace :ssl do
  desc 'Download and save CA certs from https://curl.se/ca/cacert.pem'
  task :vendor_ca_certs do
    require 'puppetfile-resolver/util'
    ca_cert_file = PuppetfileResolver::Util.static_ca_cert_file

    require 'uri'
    uri = ::URI.parse('https://curl.se/ca/cacert.pem')

    http_options = { :use_ssl => uri.class == URI::HTTPS }
    # This is a little naughty. But because we're trying to download the CA Cert file,
    # so we can stop stale CA Cert files blocking calls, we can disable verification if needed
    require 'openssl'
    http_options[:verify_mode] = OpenSSL::SSL::VERIFY_NONE if ENV['SSL_CERT_FILE'].nil?

    require 'net/http'
    response = nil
    Net::HTTP.start(uri.host, uri.port, http_options) do |http|
      request = Net::HTTP::Get.new uri
      response = http.request request
    end
    raise "Expected HTTP Code 200, but received #{response.code} for URI #{uri}: #{response.inspect}" unless response.code == '200'

    File.open(ca_cert_file, 'wb') { |f| f.write response.body }
    puts "Ruby CA Certs file has been written to #{ca_cert_file}"
  end
end

namespace :generate do
  desc 'Generate YARD docs for Github Pages'
  task :docs do
    `yard doc`
  end
end
