require 'clone_handler'
require 'json'
require 'net/http'

RSpec.describe CloneHandler do
  describe '.get_username' do
    let(:username) { 'murjax' }
    let(:prompt) { 'Please enter your Github username' }

    subject(:get_username) { described_class.get_username }

    it 'gets input from user and chomps new line' do
      expect(Kernel).to receive(:puts).with(prompt)
      expect(STDIN).to receive_message_chain(:gets, :chomp).and_return(username)
      expect(get_username).to eq(username)
    end
  end

  describe '#clone_all' do
    let(:username) { 'murjax' }
    let(:pages) { 2 }
    let(:name1) { 'spring_engine' }
    let(:name2) { 'burger_bot' }
    let(:name3) { 'wicked_pdf_capybara' }
    let(:base_url) { 'https://api.github.com' }
    let(:clone_url1) { "#{base_url}/users/#{username}/#{name1}.git" }
    let(:clone_url2) { "#{base_url}/users/#{username}/#{name2}.git" }
    let(:clone_url3) { "#{base_url}/users/#{username}/#{name3}.git" }
    let(:user_info_uri) { URI("#{base_url}/users/#{username}") }
    let(:page1_info_uri) { URI("#{base_url}/users/#{username}/repos?page=1") }
    let(:page2_info_uri) { URI("#{base_url}/users/#{username}/repos?page=2") }

    subject(:clone) { described_class.new(username).clone_all }

    before do
      stub_const('CloneHandler::PER_PAGE', 2)
    end

    context 'valid username with 1 page of repos' do
      let(:user_info) { { 'public_repos' => 2 } }
      let(:user_info_response) { OpenStruct.new(code: '200', body: JSON.generate(user_info)) }
      let(:page1_response) { OpenStruct.new(code: '200', body: JSON.generate(page1)) }
      let(:page1) do
        [
          { 'name' => name1, 'clone_url' => clone_url1 },
          { 'name' => name2, 'clone_url' => clone_url2 }
        ]
      end
      let(:command1) { "git clone #{clone_url1} #{username}/#{name1}" }
      let(:command2) { "git clone #{clone_url2} #{username}/#{name2}" }
      let(:final_command) { "#{command1} & #{command2}" }

      it 'clones the repos' do
        expect(Net::HTTP).to receive(:get_response).with(user_info_uri).and_return(user_info_response)
        expect(Net::HTTP).to receive(:get_response).with(page1_info_uri).and_return(page1_response)
        expect(Kernel).to receive(:system).with(final_command).and_return(true)

        expect(clone).to eq(true)
      end
    end

    context 'valid username with 2 pages of repos' do
      let(:user_info) { { 'public_repos' => 3 } }
      let(:user_info_response) { OpenStruct.new(code: '200', body: JSON.generate(user_info)) }
      let(:page1_response) { OpenStruct.new(code: '200', body: JSON.generate(page1)) }
      let(:page2_response) { OpenStruct.new(code: '200', body: JSON.generate(page2)) }
      let(:page1) do
        [
          { 'name' => name1, 'clone_url' => clone_url1 },
          { 'name' => name2, 'clone_url' => clone_url2 }
        ]
      end
      let(:page2) do
        [
          { 'name' => name3, 'clone_url' => clone_url3 },
        ]
      end
      let(:command1) { "git clone #{clone_url1} #{username}/#{name1}" }
      let(:command2) { "git clone #{clone_url2} #{username}/#{name2}" }
      let(:command3) { "git clone #{clone_url3} #{username}/#{name3}" }
      let(:final_command) { "#{command1} & #{command2} & #{command3}" }

      it 'clones the repos' do
        expect(Net::HTTP).to receive(:get_response).with(user_info_uri).and_return(user_info_response)
        expect(Net::HTTP).to receive(:get_response).with(page1_info_uri).and_return(page1_response)
        expect(Net::HTTP).to receive(:get_response).with(page2_info_uri).and_return(page2_response)
        expect(Kernel).to receive(:system).with(final_command).and_return(true)

        expect(clone).to eq(true)
      end
    end

    context 'valid username with no repos' do
      let(:user_info) { { 'public_repos' => 0 } }
      let(:user_info_response) { OpenStruct.new(code: '200', body: JSON.generate(user_info)) }
      let(:error_message) { 'No repositories found at this account' }

      it 'does not clone repos' do
        expect(Net::HTTP).to receive(:get_response).with(user_info_uri).and_return(user_info_response)
        expect(Net::HTTP).not_to receive(:get_response).with(page1_info_uri)
        expect(Kernel).not_to receive(:system)
        expect(Kernel).to receive(:puts).with(error_message)

        expect(clone).to eq(false)
      end
    end

    context 'username not found' do
      let(:user_info) { { 'message' => 'Not Found' } }
      let(:user_info_response) { OpenStruct.new(code: '404', body: JSON.generate(user_info)) }
      let(:error_message) { 'Not Found' }

      it 'does not clone repos' do
        expect(Net::HTTP).to receive(:get_response).with(user_info_uri).and_return(user_info_response)
        expect(Net::HTTP).not_to receive(:get_response).with(page1_info_uri)
        expect(Kernel).not_to receive(:system)
        expect(Kernel).to receive(:puts).with(error_message)

        expect(clone).to eq(false)
      end
    end

    context 'username nil' do
      let(:username) { nil }
      let(:error_message) { 'No username provided' }

      it 'does not clone repos' do
        expect(Net::HTTP).not_to receive(:get_response)
        expect(Kernel).not_to receive(:system)
        expect(Kernel).to receive(:puts).with(error_message)

        expect(clone).to eq(false)
      end
    end

    context 'username empty string' do
      let(:username) { '' }
      let(:error_message) { 'No username provided' }

      it 'does not clone repos' do
        expect(Net::HTTP).not_to receive(:get_response)
        expect(Kernel).not_to receive(:system)
        expect(Kernel).to receive(:puts).with(error_message)

        expect(clone).to eq(false)
      end
    end

    context 'network error' do
      let(:http_error) { 'Failed to open TCP connection' }
      let(:error_message) { 'Network error' }

      it 'prints error' do
        expect(Net::HTTP).to receive(:get_response).and_raise(SocketError)
        expect(Kernel).to receive(:puts).with(error_message)
        expect(Kernel).not_to receive(:system)

        expect(clone).to eq(false)
      end
    end

    context 'API rate limit exceeded at user request' do
      let(:api_error) { 'API rate limit exceeded for user' }
      let(:rate_limit_response) { { 'message' => api_error } }
      let(:error_message) { 'API rate limit exceeded for user' }
      let(:user_info_response) { OpenStruct.new(code: '403', body: JSON.generate(rate_limit_response)) }

      it 'prints error' do
        expect(Net::HTTP).to receive(:get_response).with(user_info_uri).and_return(user_info_response)
        expect(Net::HTTP).not_to receive(:get_response).with(page1_info_uri)
        expect(Kernel).not_to receive(:system)
        expect(Kernel).to receive(:puts).with(error_message)

        expect(clone).to eq(false)
      end
    end

    context 'API rate limit exceeded at repo request' do
      let(:api_error) { 'API rate limit exceeded for user' }
      let(:rate_limit_response) { { 'message' => api_error } }
      let(:error_message) { 'API rate limit exceeded for user' }
      let(:user_info) { { 'public_repos' => 3 } }
      let(:user_info_response) { OpenStruct.new(code: '200', body: JSON.generate(user_info)) }
      let(:page1_response) { OpenStruct.new(code: '403', body: JSON.generate(rate_limit_response)) }

      it 'prints error' do
        expect(Net::HTTP).to receive(:get_response).with(user_info_uri).and_return(user_info_response)
        expect(Net::HTTP).to receive(:get_response).with(page1_info_uri).and_return(page1_response)
        expect(Net::HTTP).not_to receive(:get_response).with(page2_info_uri)
        expect(Kernel).not_to receive(:system)
        expect(Kernel).to receive(:puts).with(error_message)

        expect(clone).to eq(false)
      end
    end
  end
end
