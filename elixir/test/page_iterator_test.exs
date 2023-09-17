defmodule GithubRepoCloner.PageIteratorTest do
  use ExUnit.Case
  alias GithubRepoCloner.PageIterator

  test "repeat/3: Repeat function with next page until it returns an error" do
    {:ok, page_reached} = PageIterator.repeat(&TestIteratable.runner/1, %{username: "murjax", page: 1})
    assert ^page_reached = 3
  end
end

defmodule TestIteratable do
  def runner(%{username: username, page: 1}) do
    {:ok, username}
  end

  def runner(%{username: username, page: 2}) do
    {:ok, username}
  end

  def runner(%{username: _, page: 3}) do
    {:error, "Finished"}
  end
end
