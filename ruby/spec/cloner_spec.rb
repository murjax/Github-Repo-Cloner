require "rspec"
require_relative "../methods.rb"

describe 'methods' do
  describe 'get_account_name' do
    it 'gets input from user and chomps new line' do
      allow(STDIN).to receive_message_chain(:gets, :chomp).and_return('password')
      expect(get_account_name).to eq('password')
    end
  end

  describe 'connection?' do
    context 'successful ping to github' do
      it 'is true' do
	expect(connection?).to eq(true)
      end
    end

    context 'unsuccessful ping to github' do
      it 'is false' do
	expect_any_instance_of(Net::Ping::HTTP).to receive(:ping?).and_return(false)
	expect(connection?).to eq(false)
      end
    end
  end

  describe 'github_response' do
    let(:user) { 'murjax' }
    it 'returns github response on user account' do
      response = github_response(user)
      expect(response['login']).to eq(user)
      expect(response['name']).to eq('Ryan Murphy')
      expect(response['id']).to eq(14116496)
    end
  end

  describe 'user_exists?' do
    let(:valid_user) { 'murjax' }
    let(:invalid_user) { 'lllllllllllllllllllllllllllllllllllllllll' }
    context 'user exists' do
      it 'is true' do
	expect(user_exists?(valid_user)).to eq(true)
      end
    end

    context 'user does not exist' do
      it 'is false' do
	expect(user_exists?(invalid_user)).to eq(false)
      end
    end
  end

  describe 'github_url' do
    let(:account_name) { 'murjax' }
    it 'generates github url with account name' do
      expect(github_url(account_name)).to eq("https://api.github.com/users/#{account_name}")
    end
  end

  describe 'user_missing_error' do
    it 'returns error string' do
      expect(user_missing_error).to eq('Account does not exist')
    end
  end

  describe 'no_repositories_error' do
    it 'returns error string' do
      expect(no_repositories_error).to eq('No repositories found at this account')
    end
  end

  describe 'clone_repositories' do
    it 'should clone repositories when given an account with repositories' do
      clone_repositories('password')
      expect(File.exist?('my_repositories')).to eq(true)
      `rm -rf my_repositories`
    end

    it "should not clone repositories if account has none" do
      clone_repositories('llllll')
      expect(File.exist?('my_repositories')).to eq(false)
      `rm -rf my_repositories`
    end
  end

  describe 'clone_repository' do
    let(:repo) { { 'clone_url' => 'https://foobar.com', 'name' => 'foobar' } }
    let(:git) { double(:git, add_remote: true) }
    it 'clones repository with clone url' do
      expect(Git).to receive(:clone).and_return(git)
      clone_repository(repo)
    end
  end

  describe 'repositories' do
    let(:account_name) { 'murjax' }
    let(:page) { 1 }

    it 'returns response of user repo data' do
      response = repositories(account_name, page)
      expect(response.first['id']).to eq(97072612)
      expect(response.first['name']).to eq('actionchat')
    end
  end
end
