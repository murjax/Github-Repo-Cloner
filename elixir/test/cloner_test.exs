defmodule ClonerTest do
  use ExUnit.Case

  test "#execute_github_clone" do
    clone_url = "https://github.com/murjax/spring_engine.git"
    Cloner.execute_github_clone(clone_url)
    result = System.cmd("ls", [])
    System.cmd("rm", ["-rf", "spring_engine"])
  end
end
