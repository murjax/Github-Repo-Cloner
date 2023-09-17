require_relative 'clone_page_handler'

class CloneAllHandler
  def initialize(username)
    @username = username
    @page = 1
    @has_next_page = true
  end

  def call
    while has_next_page
      self.has_next_page = ClonePageHandler.new(username, page).call
      self.page += 1
    end
  end

  private

  attr_reader :username
  attr_accessor :page, :has_next_page
end
