# Github-Repo-Cloner
This Ruby script clones a given user's repositories from Github and sets up remotes for each one. This is convenient for 
those who have recently switched to another development machine and need quick access to their projects.

#How to use

Place `github_repo_cloner.rb` or `github_repo_cloner.py` into the folder where you wish to store your repositories. Then call `ruby github_repo_cloner.rb` or `python github_repo_cloner.rb`
from your terminal.

A prompt will appear asking for a github account name. Provide it with the username of the account you wish to clone from.

```
Please enter your Github account name
***Your username***
```

The clone URLs of each repository will appear in the terminal as they are saved. When it is completed, you will have a folder
called "my_repositories" that will contain all the cloned repositories.

The remotes will be already setup, so you may immediately push commits back to Github from these repositories. This remote's
name is "originate", as opposed to the commonly used "origin". This is to prevent conflicts with a possibly existing "origin" remote
on your machine.
