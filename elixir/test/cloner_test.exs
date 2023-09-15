defmodule GithubRepoCloner.ClonerTest do
  use ExUnit.Case
  import Mox
  alias GithubRepoCloner.Cloner

  test "clone_page\1: valid username with repos" do
    username = "murjax"
    page = "2"
    clone_url1 = "https://github.com/murjax/spring_engine.git"
    clone_url2 = "https://github.com/murjax/burger_bot.git"
    name1 = "spring_engine"
    name2 = "burger_bot"
    repo_info = [
      %{"name" => name1, "clone_url" => clone_url1},
      %{"name" => name2, "clone_url" => clone_url2}
    ]
    command1 = "git clone #{clone_url1} #{username}/#{name1}"
    command2 = "git clone #{clone_url2} #{username}/#{name2}"
    final_command = "#{command1} & #{command2}"
    expected_result = {:ok, "Command executed: #{final_command}"}

    {_, serialized_repo_info} = Poison.encode(repo_info)
    expect(
      GithubRepoCloner.Http.Mock, :get, fn _url ->
        {:ok, %Tesla.Env{status: 200, body: serialized_repo_info}}
      end)

    {:ok, result} = Cloner.clone_page(%{username: username, page: page})
    assert ^result = expected_result
  end

  test "clone_page\1: valid username without repos" do
    username = "murjax"
    page = "2"

    expect(
      GithubRepoCloner.Http.Mock, :get, fn _url ->
        {:ok, %Tesla.Env{status: 200, body: "[]"}}
      end)

    {:error, result} = Cloner.clone_page(%{username: username, page: page})
    assert ^result = "No repositories found"
  end

  test "clone_page\1: username not found" do
    username = "foo"
    page = "2"
    response_body = %{"message" => "Not Found"}
    {_, serialized_response_body} = Poison.encode(response_body)

    expect(
      GithubRepoCloner.Http.Mock, :get, fn _url ->
        {:ok, %Tesla.Env{status: 404, body: serialized_response_body}}
      end)

    {:error, result} = Cloner.clone_page(%{username: username, page: page})
    assert ^result = "No repositories found"
  end

  test "clone_page/1: nil username" do
    {:error, result} = Cloner.clone_page(%{username: nil, page: nil})
    assert ^result = "No repositories found"
  end

  test "clone_page/1: nil page" do
    username = "murjax"
    {:error, result} = Cloner.clone_page(%{username: username, page: nil})
    assert ^result = "No repositories found"
  end
end
