import requests
import subprocess

def clone(username):
    if username == None or username == '':
        return

    repositories = get_repositories(username)
    if len(repositories) == 0:
        return

    commands = map(create_command, repositories)
    final_command = ' & '.join(commands)
    subprocess.run(final_command, shell=True, check=False)

def create_command(repo_info):
    return 'git clone ' + repo_info['clone_url']

def get_repositories(username):
    response = requests.get("https://api.github.com/users/" + username + "/repos")
    if response.status_code != 200:
        return []

    return response.json()
