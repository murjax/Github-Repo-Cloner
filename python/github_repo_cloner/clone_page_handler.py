import subprocess
import requests

def clone(username, page):
    if username in (None, ''):
        return False

    repositories = get_repositories(username, page)
    if len(repositories) == 0:
        return False

    commands = map(lambda repo_info: create_command(repo_info, username), repositories)
    final_command = ' & '.join(commands)
    subprocess.run(final_command, shell=True, check=False)
    return True

def create_command(repo_info, username):
    return f'git clone {repo_info["clone_url"]} {username}/{repo_info["name"]}'

def get_repositories(username, page):
    response = requests.get(f'https://api.github.com/users/{username}/repos?page={page}')
    if response.status_code != 200:
        return []

    return response.json()
