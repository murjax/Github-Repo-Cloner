require "rspec"
require_relative "../methods.rb"

describe "possible http interactions with Github API" do
  it 'input account name should not have new line' do
    allow(STDIN).to receive_message_chain(:gets, :chomp).and_return('password')
    expect(get_account_name).to eq('password')
  end

  it "should detect if a user exists" do
    expect(user_exists('murjax')).to eq(true)
  end

  it "should detect if a user does not exist" do
    expect(user_exists('lllllllllllllllllllllllllllllllllllllllll')).to eq(false)
  end

  it 'should be able to ping Github' do
    expect(connection?).to eq(true)
  end

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
