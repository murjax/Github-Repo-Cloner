require 'rspec'
require_relative '../github_repo_handler.rb'

describe 'GithubRepoHandler' do
  let(:account_name) { 'password' }
  let(:github_repo_handler) { GithubRepoHandler.new }

  before(:each) do
    allow(STDIN).to receive_message_chain(:gets, :chomp).and_return(account_name)
  end

  describe 'get_account_name' do
    it 'gets input from user and chomps new line' do
      expect(github_repo_handler.get_account_name).to eq(account_name)
    end
  end

  describe 'connection?' do
    context 'successful ping to github' do
      it 'is true' do
	expect(Error).not_to receive(:network_error)
	expect(github_repo_handler.connection?).to eq(true)
      end
    end

    context 'unsuccessful ping to github' do
      it 'is false' do
	expect_any_instance_of(Net::Ping::HTTP).to receive(:ping?).and_return(false)
	expect(Error).to receive(:network_error)
	expect(github_repo_handler.connection?).to eq(false)
      end
    end
  end

  describe 'github_url' do
    it 'generates github url with account name' do
      url = "https://api.github.com/users/#{account_name}"
      expect(github_repo_handler.github_url).to eq(url)
    end
  end

  describe 'github_user_info_request' do
    let(:account_name) { 'murjax' }
    it 'returns github response on user account' do
      response = github_repo_handler.github_user_info_request
      expect(response['login']).to eq(account_name)
      expect(response['name']).to eq('Ryan Murphy')
      expect(response['id']).to eq(14116496)
    end
  end

  describe 'user_exists?' do
    context 'user exists' do
      it 'is true' do
	expect(Error).not_to receive(:user_missing_error)
	expect(github_repo_handler.user_exists?).to eq(true)
      end
    end

    context 'user does not exist' do
      let(:account_name) { 'lllllllllllllllllllllllllllllllllllllllll' }
      it 'is false' do
	expect(Error).to receive(:user_missing_error)
	expect(github_repo_handler.user_exists?).to eq(false)
      end
    end
  end

  describe 'repositories' do
    let(:account_name) { 'murjax' }
    let(:page) { 1 }

    it 'returns response of user repo data' do
      response = github_repo_handler.github_repo_request(page)
      expect(response.first['id']).to eq(97072612)
      expect(response.first['name']).to eq('actionchat')
    end
  end

  describe 'clone_repository' do
    let(:repo) { { 'clone_url' => 'https://foobar.com', 'name' => 'foobar' } }
    let(:git) { double(:git, add_remote: true) }
    it 'clones repository with clone url' do
      expect(Git).to receive(:clone).and_return(git)
      github_repo_handler.clone_repository(repo)
    end
  end

  describe 'repositories_exist?' do
    let(:page) { 1 }
    describe 'repositories exist' do
      it 'is true' do
	expect_any_instance_of(GithubRepoHandler).to receive(:github_repo_request).and_return([1])
	expect(github_repo_handler.repositories_exist?(page)).to eq(true)
      end
    end

    describe 'repositories do not exist' do
      it 'is false' do
	expect_any_instance_of(GithubRepoHandler).to receive(:github_repo_request).and_return([])
	expect(Error).to receive(:no_repositories_error)
	expect(github_repo_handler.repositories_exist?(page)).to eq(false)
      end
    end
  end

  describe 'clone_repositories' do
    context 'no account' do
      let(:account_name) { 'lllllllllllllllllllllllllllllllllllllllll' }
      it 'does not clone repos' do
	expect_any_instance_of(GithubRepoHandler).not_to receive(:github_repo_request)
	github_repo_handler.clone_repositories
      end
    end

    context 'no connection' do
      it 'does not clone repos' do
	expect_any_instance_of(GithubRepoHandler).to receive(:connection?).and_return(false)
	github_repo_handler.clone_repositories
      end
    end

    context 'account with repos' do
      it 'clones repos' do
	github_repo_handler.clone_repositories
	expect(File.exist?('my_repositories')).to eq(true)
	`rm -rf my_repositories`
      end
    end

    context 'account without repos' do
      let(:account_name) { 'llllll' }
      it "should not clone repositories if account has none" do
	github_repo_handler.clone_repositories
	expect(File.exist?('my_repositories')).to eq(false)
	`rm -rf my_repositories`
      end
    end
  end

  describe 'parse_response' do
    it 'parses JSON API response into hash' do
      username = 'murjax'
      url = "https://api.github.com/users/#{username}"
      response = github_repo_handler.parse_response(url)
      expect(response['login']).to eq(username)
    end
  end
end
