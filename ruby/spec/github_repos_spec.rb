require 'rspec'
require_relative '../github_account.rb'
require_relative '../github_repos.rb'

describe 'GithubRepos' do
  let(:account_name) { 'murjax' }
  let(:github_account) { GithubAccount.new(account_name) }
  describe '#all' do
    subject { GithubRepos.new(github_account).all }
    it 'is GitHub data for all account repos' do
      expect(subject.first['owner']['login']).to eq(account_name)
    end
  end
end
