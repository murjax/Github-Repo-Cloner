require 'rspec'
require_relative '../github_api.rb'

describe 'GithubAPI' do
  let(:account_name) { 'password' }

  describe '#clone_repositories' do
    subject { GithubAPI.new(account_name).clone_repositories }
    it 'clones all account repositories' do
      subject
      expect(File.exist?('my_repositories/python-code-shifter')).to eq(true)
      `rm -rf my_repositories`
    end
  end
end
