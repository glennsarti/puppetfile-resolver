require 'spec_helper'
require 'puppetfile-resolver/puppetfile'
require 'puppetfile-resolver/puppetfile/git_module'

RSpec.describe 'PuppetfileResolver::Puppetfile::GitModule' do

  let(:url) { 'https://github.com/vshn/puppet-gitlab' }
  let(:title) { 'gitlab' }

  let(:instance) do
    instance = PuppetfileResolver::Puppetfile::GitModule.new(title)
    instance.remote = url
    instance
  end

  it '#new' do
    expect(PuppetfileResolver::Puppetfile::GitModule.new(title)).to be_a PuppetfileResolver::Puppetfile::GitModule
  end 

  it 'should not run_command more than once' do
    i = PuppetfileResolver::Puppetfile::GitModule.new(title)
    i.remote = url
    expect(i).to receive(:run_command).with("git ls-remote --symref #{url}").once
    i.valid_url?
    i.all_refs
  end

  describe 'good url' do
    let(:url) { 'https://github.com/vshn/puppet-gitlab' }

    let(:reflist) { File.read(File.join(fixtures_dir, 'refs', 'gitlab.txt')) }

    before(:each) do
      allow(instance).to receive(:run_command).with("git ls-remote --symref #{url}").and_return([reflist, true])
    end

    it '#remote_refs is array' do
      expect(instance.remote_refs).to be_a Array
    end

    it '#remote_refs contains refs' do
      expect(instance.remote_refs.first).to eq("1b3322d525e96bf7d0565b08703e2a44c90e7b4a\tHEAD\n")
    end

    it '#valid_ref?' do
      expect(instance.valid_ref?('master')).to be true
    end
  
    it '#valid_commit?' do
      expect(instance.valid_commit?('master')).to be true
    end

    it '#valid_commit? and nil sha' do
      expect(instance.valid_commit?(nil)).to be false
    end

    it '#valid_commit? but invalid sha' do
      allow(instance).to receive(:run_command).with(/clone/, silent: true).and_return([nil, true])
      allow(instance).to receive(:run_command).with(/git\sshow.*/, silent: true).and_return([nil, false])
      expect(instance.valid_commit?('invalid')).to be false
    end

    it '#valid_url?' do
      expect(instance.valid_url?).to be true
    end

    it '#all_refs is a Array of Hashes' do
      refs = instance.all_refs
      expect(refs).to be_a Array
      expect(refs.last).to eq(
        {:name=>"v5.0.0^{}", :ref=>"refs/tags/v5.0.0^{}", :sha=>"1febd15f90d32e6b3d6c242a70db386b2ef1942c", :subtype=>nil, :type=>:tag}
      )
    end
  end

  describe 'bad url' do
    let(:url) { 'https://github.com/nwops/typo' }

    before(:each) do
      allow(instance).to receive(:run_command).with("git ls-remote --symref #{url}").and_return(["", false])
    end

    it '#all_refs' do
      expect(instance.all_refs).to be_a Array
      expect(instance.all_refs).to eq []
    end
  end
end
