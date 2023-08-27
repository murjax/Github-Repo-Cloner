defmodule Cloner do
  def clone(username) do
    url = "https://api.github.com/users/#{username}/repos"
    headers = ["User-Agent": "Elixir"]
    response = HTTPotion.get url, headers: headers
    data = elem(Poison.decode(response.body), 1)
    clone_urls = Enum.map(data, fn(item) -> item["clone_url"] end)
    Enum.each(clone_urls, fn(url) -> spawn(fn -> execute_github_clone(url) end) end)
  end

  def execute_github_clone(clone_url) do
    System.cmd("git", ["clone", clone_url])
  end
end
