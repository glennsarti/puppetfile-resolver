require 'spec_helper'
require 'puppetfile-resolver/spec_searchers/git/gclone'
require 'puppetfile-resolver/spec_searchers/git_configuration'
require 'logger'
require 'json'

describe PuppetfileResolver::SpecSearchers::Git::GClone do
  PuppetfileModule = Struct.new(:remote, :ref, :branch, :commit, :tag, keyword_init: true)
  config = PuppetfileResolver::SpecSearchers::Configuration.new
  config.local.puppet_module_paths = [File.join(FIXTURES_DIR, 'modulepath')]

  let(:url) do
    'https://github.com/puppetlabs/puppetlabs-powershell'
  end

  let(:puppetfile_module) do
    PuppetfileModule.new(remote: url)
  end


  context 'valid url' do
    it 'reads metadata' do
      content = subject.metadata(puppetfile_module, Logger.new(STDERR), config)
      expect(JSON.parse(content)['name']).to eq('puppetlabs-powershell')
    end

    context 'with ref' do

      let(:puppetfile_module) do
        PuppetfileModule.new(remote: url, ref: '2.1.2')
      end

      it 'reads metadata' do
        content = subject.metadata(puppetfile_module, Logger.new(STDERR), config)
        expect(JSON.parse(content)['name']).to eq('puppetlabs-powershell')
      end
    end
  end

  context 'invalid url' do
    let(:url) do
      'https://github.com/puppetlabs/puppetlabs-powershellbad'
    end

    it 'throws exception' do
      expect{subject.metadata(puppetfile_module, Logger.new(STDERR), config)}
      .to raise_exception(RuntimeError)
    end
  end
end
