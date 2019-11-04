require 'spec_helper'

require 'puppetfile-resolver/puppetfile/parser/r10k_eval'

RSpec.shared_examples "a puppetfile parser with valid content" do
  let(:puppetfile_content) do
    <<-EOT
    forge 'https://fake-forge.puppetlabs.com/'

    mod 'puppetlabs-forge_fixed_ver', '1.0.0'
    mod 'puppetlabs-forge_latest',    :latest

    mod 'git_branch',
      :git => 'git@github.com:puppetlabs/puppetlabs-git_branch.git',
      :branch => 'branch'

    mod 'git_ref',
    :git => 'git@github.com:puppetlabs/puppetlabs-git_ref.git',
    :ref => 'branch'

    mod 'git_commit',
      :git => 'git@github.com:puppetlabs/puppetlabs-git_commit.git',
      :commit => 'abc123'

    mod 'git_tag',
      :git => 'git@github.com:puppetlabs/puppetlabs-git_tag.git',
      :tag => '0.1'

    mod 'local', :local => 'some/path'

    mod 'svn_min', :svn => 'some-svn-repo'

    EOT
  end
  let(:puppetfile) { subject.parse(puppetfile_content) }

  def get_module(document, title)
    document.modules.find { |mod| mod.title == title }
  end

  it "should set the forge uri" do
    expect(puppetfile.forge_uri).to eq('https://fake-forge.puppetlabs.com/')
  end

  it "should return the Puppetfile content" do
    expect(puppetfile.content).to eq(puppetfile_content)
  end

  it "should detect all of the modules" do
    expect(puppetfile.modules.count).to eq(8)
  end

  context 'with Forge modules' do
    it 'should detect forge fixed version modules' do
      mod = get_module(puppetfile, 'puppetlabs-forge_fixed_ver')

      expect(mod.module_type).to eq(PuppetfileResolver::Puppetfile::FORGE_MODULE)
      expect(mod.title).to eq('puppetlabs-forge_fixed_ver')
      expect(mod.owner).to eq('puppetlabs')
      expect(mod.name).to eq('forge_fixed_ver')
      expect(mod.version).to eq('1.0.0')
      expect(mod.location.start_line).to eq(2)
      expect(mod.location.start_char).to be_nil
      expect(mod.location.end_line).to eq(2)
      expect(mod.location.end_char).to  be_nil
    end

    it 'should detect forge latest version modules' do
      mod = get_module(puppetfile, 'puppetlabs-forge_latest')

      expect(mod.module_type).to eq(PuppetfileResolver::Puppetfile::FORGE_MODULE)
      expect(mod.title).to eq('puppetlabs-forge_latest')
      expect(mod.owner).to eq('puppetlabs')
      expect(mod.name).to eq('forge_latest')
      expect(mod.version).to eq(:latest)
      expect(mod.location.start_line).to eq(3)
      expect(mod.location.start_char).to be_nil
      expect(mod.location.end_line).to eq(3)
      expect(mod.location.end_char).to  be_nil
    end
  end

  context 'with Git modules' do
    it 'should detect git branch modules' do
      mod = get_module(puppetfile, 'git_branch')

      expect(mod.module_type).to eq(PuppetfileResolver::Puppetfile::GIT_MODULE)
      expect(mod.title).to eq('git_branch')
      expect(mod.owner).to be_nil
      expect(mod.name).to eq('git_branch')
      expect(mod.version).to be_nil
      expect(mod.remote).to eq('git@github.com:puppetlabs/puppetlabs-git_branch.git')
      expect(mod.ref).to eq('branch')
      expect(mod.commit).to be_nil
      expect(mod.tag).to be_nil
      expect(mod.location.start_line).to eq(5)
      expect(mod.location.start_char).to be_nil
      expect(mod.location.end_line).to eq(5)
      expect(mod.location.end_char).to  be_nil
    end

    it 'should detect git ref modules' do
      mod = get_module(puppetfile, 'git_ref')

      expect(mod.module_type).to eq(PuppetfileResolver::Puppetfile::GIT_MODULE)
      expect(mod.title).to eq('git_ref')
      expect(mod.owner).to be_nil
      expect(mod.name).to eq('git_ref')
      expect(mod.version).to be_nil
      expect(mod.remote).to eq('git@github.com:puppetlabs/puppetlabs-git_ref.git')
      expect(mod.ref).to eq('branch')
      expect(mod.commit).to be_nil
      expect(mod.tag).to be_nil
      expect(mod.location.start_line).to eq(9)
      expect(mod.location.start_char).to be_nil
      expect(mod.location.end_line).to eq(9)
      expect(mod.location.end_char).to  be_nil
    end

    it 'should detect git commit modules' do
      mod = get_module(puppetfile, 'git_commit')

      expect(mod.module_type).to eq(PuppetfileResolver::Puppetfile::GIT_MODULE)
      expect(mod.title).to eq('git_commit')
      expect(mod.owner).to be_nil
      expect(mod.name).to eq('git_commit')
      expect(mod.version).to be_nil
      expect(mod.remote).to eq('git@github.com:puppetlabs/puppetlabs-git_commit.git')
      expect(mod.ref).to be_nil
      expect(mod.commit).to eq('abc123')
      expect(mod.tag).to be_nil
      expect(mod.location.start_line).to eq(13)
      expect(mod.location.start_char).to be_nil
      expect(mod.location.end_line).to eq(13)
      expect(mod.location.end_char).to  be_nil
    end

    it 'should detect git tag modules' do
      mod = get_module(puppetfile, 'git_tag')

      expect(mod.module_type).to eq(PuppetfileResolver::Puppetfile::GIT_MODULE)
      expect(mod.title).to eq('git_tag')
      expect(mod.owner).to be_nil
      expect(mod.name).to eq('git_tag')
      expect(mod.version).to be_nil
      expect(mod.remote).to eq('git@github.com:puppetlabs/puppetlabs-git_tag.git')
      expect(mod.ref).to be_nil
      expect(mod.commit).to be_nil
      expect(mod.tag).to eq('0.1')
      expect(mod.location.start_line).to eq(17)
      expect(mod.location.start_char).to be_nil
      expect(mod.location.end_line).to eq(17)
      expect(mod.location.end_char).to  be_nil
    end
  end

  context 'with Local modules' do
    it 'should detect local modules' do
      mod = get_module(puppetfile, 'local')

      expect(mod.module_type).to eq(PuppetfileResolver::Puppetfile::LOCAL_MODULE)
      expect(mod.title).to eq('local')
      expect(mod.owner).to be_nil
      expect(mod.name).to eq('local')
      expect(mod.version).to be_nil
      expect(mod.location.start_line).to eq(21)
      expect(mod.location.start_char).to be_nil
      expect(mod.location.end_line).to eq(21)
      expect(mod.location.end_char).to  be_nil
    end
  end

  context 'with SVN modules' do
    it 'should detect svn modules' do
      mod = get_module(puppetfile, 'svn_min')

      expect(mod.module_type).to eq(PuppetfileResolver::Puppetfile::SVN_MODULE)
      expect(mod.title).to eq('svn_min')
      expect(mod.owner).to be_nil
      expect(mod.name).to eq('svn_min')
      expect(mod.version).to be_nil
      expect(mod.remote).to eq('some-svn-repo')
      expect(mod.location.start_line).to eq(23)
      expect(mod.location.start_char).to be_nil
      expect(mod.location.end_line).to eq(23)
      expect(mod.location.end_char).to  be_nil
    end
  end
end

RSpec.shared_examples "a puppetfile parser with invalid content" do
  let(:puppetfile_content) do
    <<-EOT
    forge 'https://fake-forge.puppetlabs.com/'

    mod 'puppetlabs-bad_version', 'b.c.d'
    mod 'puppetlabs-missing_version'

    mod 'bad_args',
      :gitx => 'git@github.com:puppetlabs/puppetlabs-git_ref.git'

    EOT
  end
  let(:puppetfile) { subject.parse(puppetfile_content) }

  def get_module(document, title)
    document.modules.find { |mod| mod.title == title }
  end

  it "should detect all of the invalid modules" do
    expect(puppetfile.modules.count).to eq(3)

    puppetfile.modules.each do |mod|
      expect(mod).to have_attributes(:module_type => PuppetfileResolver::Puppetfile::INVALID_MODULE)
      expect(mod.reason).to_not be_nil
    end
  end
end

RSpec.shared_examples "a puppetfile parser which raises" do
  [
    {
      name: 'with an unknown method',
      content: "mod_abc 'puppetlabs-forge_fixed_ver', '1.0.0'\n",
    },
    {
      name: 'with a bad forge module name',
      content: "mod 'bad\nname', '1.0.0'\n",
    },
    {
      name: 'with a syntax error',
      content: "} # syntax\n",
    },
    {
      name: 'with a syntax error in the middle of the line',
      content: "forge 'something' } # syntax\n",
    },
    {
      name: 'with an unknown require',
      content: "require 'not_loadable' # I am a load error\n",
    },
    {
      name: 'with a runtime error',
      content: "raise 'A Mock Runtime Error'\n",
    },
  ].each_with_index do |testcase, testcase_index|
    context "Given a puppetfile with #{testcase[:name]}" do
      let(:puppetfile_content) do
        # Add interesting things to the puppetfile content, so it's not just a single line
        "# Padding\n" * testcase_index + testcase[:content] + "# Padding\n" * testcase_index
      end
      let(:expected_error_line) { testcase_index }

      it "should raise a parsing error" do
        expect{ subject.parse(puppetfile_content) }.to raise_error(PuppetfileResolver::Puppetfile::Parser::ParserError)
      end

      it "should locate the error in the puppetfile" do
        begin
          subject.parse(puppetfile_content)
        rescue PuppetfileResolver::Puppetfile::Parser::ParserError => e
          expect(e.location.start_line).to eq(expected_error_line)
          expect(e.location.end_line).to eq(expected_error_line)
          # TODO: What about character position?
        end
      end
    end
  end
end

describe PuppetfileResolver::Puppetfile::Parser::R10KEval do
  let(:subject) { PuppetfileResolver::Puppetfile::Parser::R10KEval }

  it_behaves_like "a puppetfile parser with valid content"

  it_behaves_like "a puppetfile parser with invalid content"

  it_behaves_like "a puppetfile parser which raises"
end
