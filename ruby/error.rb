class Error
  def self.network_error
    'Network error'
  end

  def self.user_missing_error
    'Account does not exist'
  end

  def self.no_repositories_error
    'No repositories found at this account'
  end
end
