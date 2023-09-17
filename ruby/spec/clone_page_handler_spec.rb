require 'clone_page_handler'
require 'json'
require 'net/http'

RSpec.describe ClonePageHandler do
  describe '#call' do
    let(:username) { 'murjax' }
    let(:page) { 2 }
    let(:clone_url1) { 'https://github.com/murjax/spring_engine.git' }
    let(:clone_url2) { 'https://github.com/murjax/burger_bot.git' }
    let(:name1) { 'spring_engine' }
    let(:name2) { 'burger_bot' }
    let(:repo_info_url) { "https://api.github.com/users/#{username}/repos?page=#{page}" }
    let(:repo_info_uri) { URI(repo_info_url) }
    let(:serialized_response_body) { JSON.generate(response_body) }
    let(:response) { OpenStruct.new(code: code, body: serialized_response_body) }

    subject(:call) { described_class.new(username, page).call }

    context 'valid username with repos' do
      let(:response_body) do
        [
          { 'name' => name1, 'clone_url' => clone_url1 },
          { 'name' => name2, 'clone_url' => clone_url2 }
        ]
      end
      let(:code) { '200' }
      let(:command1) { "git clone #{clone_url1} #{username}/#{name1}" }
      let(:command2) { "git clone #{clone_url2} #{username}/#{name2}" }
      let(:final_command) { "#{command1} & #{command2}" }

      it 'runs clone commands' do
        expect(Net::HTTP).to receive(:get_response).with(repo_info_uri).and_return(response)
        expect(Kernel).to receive(:system).with(final_command).and_return(true)

        expect(call).to eq(true)
      end
    end

    context 'valid username without repos' do
      let(:serialized_response_body) { '[]' }
      let(:code) { '200' }

      it 'does not run clone commands' do
        expect(Net::HTTP).to receive(:get_response).with(repo_info_uri).and_return(response)
        expect(Kernel).not_to receive(:system)

        expect(call).to eq(false)
      end
    end

    context 'username not found' do
      let(:response_body) { { 'message' => 'Not found' } }
      let(:code) { '404' }

      it 'does not run clone commands' do
        expect(Net::HTTP).to receive(:get_response).with(repo_info_uri).and_return(response)
        expect(Kernel).not_to receive(:system)

        expect(call).to eq(false)
      end
    end

    context 'username nil' do
      let(:username) { nil }

      it 'does not run request or clone commands' do
        expect(Net::HTTP).not_to receive(:get_response)
        expect(Kernel).not_to receive(:system)

        expect(call).to eq(false)
      end
    end

    context 'username empty string' do
      let(:username) { '' }

      it 'does not run request or clone commands' do
        expect(Net::HTTP).not_to receive(:get_response)
        expect(Kernel).not_to receive(:system)

        expect(call).to eq(false)
      end
    end
  end
end
