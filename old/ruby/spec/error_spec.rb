require 'rspec'
require_relative '../error.rb'

describe 'Error' do
  describe 'user_missing_error' do
    it 'returns error string' do
      error = 'Account does not exist'
      expect(Error.user_missing_error).to eq(error)
    end
  end

  describe 'network_error' do
    it 'returns error string' do
      error = 'Network error'
      expect(Error.network_error).to eq(error)
    end
  end

  describe 'no_repositories_error' do
    it 'returns error string' do
      error = 'No repositories found at this account'
      expect(Error.no_repositories_error).to eq(error)
    end
  end
end
