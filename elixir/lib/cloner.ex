defmodule GithubRepoCloner.Cloner do
  @http_client Application.compile_env(:github_repo_cloner, :http_client)
  @system Application.compile_env(:github_repo_cloner, :system)

  def clone_page(%{username: nil}), do: {:error, "No repositories found"}
  def clone_page(%{page: nil}), do: {:error, "No repositories found"}

  def clone_page(%{username: username, page: page}) do
    username
    |> request_repo_info(page)
    |> parse_response
    |> clone_repos(username)
  end

  defp request_repo_info(username, page) do
    @http_client.get("https://api.github.com/users/#{username}/repos?page=#{page}")
  end

  defp parse_response({:ok, %Tesla.Env{status: 200, body: body}}) do
    elem(Poison.decode(body), 1)
  end

  defp parse_response({:ok, %Tesla.Env{status: _}}), do: []

  defp clone_repos(repo_info, username) do
    repo_info
    |> Enum.map(fn(%{"clone_url" => clone_url, "name" => name}) -> "git clone #{clone_url} #{username}/#{name}" end)
    |> Enum.join(" & ")
    |> run_command
  end

  defp run_command("") do
    {:error, "No repositories found"}
  end

  defp run_command(command) do
    {:ok, @system.cmd("sh", ["-c", command])}
  end
end
