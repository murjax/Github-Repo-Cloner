defmodule GithubRepoCloner.ClonerTest do
  use ExUnit.Case
  import Mox
  alias GithubRepoCloner.Cloner

  test "clone\1: valid username with repos" do
    username = "murjax"
    clone_url1 = "https://github.com/murjax/spring_engine.git"
    clone_url2 = "https://github.com/murjax/burger_bot.git"
    repo_info = [%{"clone_url" => clone_url1}, %{"clone_url" => clone_url2}]
    command1 = "git clone #{clone_url1}"
    command2 = "git clone #{clone_url2}"
    final_command = "#{command1} & #{command2}"
    expected_result = {:ok, "Command executed: #{final_command}"}

    {_, serialized_repo_info} = Poison.encode(repo_info)
    expect(
      GithubRepoCloner.Http.Mock, :get, fn _url ->
        {:ok, %Tesla.Env{status: 200, body: serialized_repo_info}}
      end)

    result = Cloner.clone(username)
    assert ^result = expected_result
  end

  test "clone\1: valid username without repos" do
    username = "murjax"
    expected_result = {:ok, "Command executed: "}

    expect(
      GithubRepoCloner.Http.Mock, :get, fn _url ->
        {:ok, %Tesla.Env{status: 200, body: "[]"}}
      end)

    result = Cloner.clone(username)
    assert ^result = expected_result
  end

  test "clone\1: username not found" do
    username = "foo"
    expected_result = {:ok, "Command executed: "}
    response_body = %{"message" => "Not Found"}
    {_, serialized_response_body} = Poison.encode(response_body)

    expect(
      GithubRepoCloner.Http.Mock, :get, fn _url ->
        {:ok, %Tesla.Env{status: 404, body: serialized_response_body}}
      end)

    result = Cloner.clone(username)
    assert ^result = expected_result
  end

  test "clone\1: nil" do
    result = Cloner.clone(nil)
    assert ^result = true
  end

  test "clone\0: valid noop" do
    result = Cloner.clone
    assert ^result = true
  end
end
