defmodule GithubRepoCloner.Cloner do
  @http_client Application.compile_env(:github_repo_cloner, :http_client)
  @system Application.compile_env(:github_repo_cloner, :system)

  def clone(nil), do: true

  def clone(username) do
    username
    |> request_repo_info
    |> parse_response
    |> clone_repos
  end

  def clone, do: true

  defp request_repo_info(username) do
    @http_client.get("https://api.github.com/users/#{username}/repos")
  end

  defp parse_response({:ok, %Tesla.Env{status: 200, body: body}}) do
    elem(Poison.decode(body), 1)
  end

  defp parse_response({:ok, %Tesla.Env{status: _}}), do: []

  defp clone_repos(repo_info) do
    repo_info
    |> Enum.map(fn(item) -> "git clone #{item["clone_url"]}" end)
    |> Enum.join(" & ")
    |> run_command
  end

  defp run_command(command) do
    @system.cmd("sh", ["-c", command])
  end
end
