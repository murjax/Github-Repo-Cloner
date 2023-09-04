defmodule GithubRepoCloner.MockSystem do
  def cmd("sh", ["-c", command]) do
    {:ok, "Command executed: #{command}"}
  end
end
