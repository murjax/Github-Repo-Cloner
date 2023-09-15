defmodule GithubRepoCloner.PageIterator do
  def repeat(function, arguments = %{page: page}) do
    {status, _} = function.(%{arguments | page: page})
    repeat(function, arguments, status)
  end

  def repeat(function, arguments = %{page: page}, :ok) do
    repeat(function, %{arguments | page: page + 1})
  end

  def repeat(_function, %{page: page}, :error), do: {:ok, page}
end
