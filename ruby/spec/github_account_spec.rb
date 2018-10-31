require 'rspec'
require_relative '../github_account.rb'

describe 'GithubAccount' do
  let(:account_name) { 'murjax' }
  describe '#url' do
    subject { GithubAccount.new(account_name).url }
    it 'is GitHub url of given account name' do
      expect(subject).to eq("https://api.github.com/users/#{account_name}")
    end
  end

  describe '#exists?' do
    subject { GithubAccount.new(account_name).exists? }
    context 'real account' do
      let(:account_name) { 'murjax' }
      it 'is true' do
        expect(subject).to eq(true)
      end
    end

    context 'fake account' do
      let(:account_name) { 'sdfasdflop' }
      it 'is false' do
        expect(subject).to eq(false)
      end
    end
  end
end
