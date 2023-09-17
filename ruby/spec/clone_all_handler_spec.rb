require 'clone_all_handler'
require 'clone_page_handler'

RSpec.describe CloneAllHandler do
  describe '#call' do
    let(:username) { 'murjax' }

    subject(:call) { described_class.new(username).call }

    it 'calls ClonePageHandler with each page until blank page reached' do
      expect(ClonePageHandler).to receive(:new).with(username, 1).and_return(OpenStruct.new(call: true))
      expect(ClonePageHandler).to receive(:new).with(username, 2).and_return(OpenStruct.new(call: true))
      expect(ClonePageHandler).to receive(:new).with(username, 3).and_return(OpenStruct.new(call: false))

      call
    end
  end
end
