import unittest
from unittest.mock import MagicMock, patch
import github_repo_cloner.clone_handler

class TestCloneHandler(unittest.TestCase):
    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    def test_cloner_success(self, mock_requests, mock_subprocess):
        username = 'murjax'
        repo_info_url = "https://api.github.com/users/" + username + "/repos"
        clone_url1 = 'https://github.com/murjax/spring_engine.git'
        clone_url2 = 'https://github.com/murjax/burger_bot.git'
        name1 = 'spring_engine'
        name2 = 'burger_bot'
        command1 = f'git clone {clone_url1} {username}/{name1}'
        command2 = f'git clone {clone_url2} {username}/{name2}'
        final_command = command1 + ' & ' + command2
        expected_response = [
            { 'name': name1, 'clone_url': clone_url1 },
            { 'name': name2, 'clone_url': clone_url2 }
        ]
        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_response.json.return_value = expected_response
        mock_requests.get.return_value = mock_response
        github_repo_cloner.clone_handler.clone(username)
        mock_requests.get.assert_called_with(repo_info_url)
        mock_subprocess.run.assert_called_with(final_command, shell=True, check=False)

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    def test_cloner_no_repos(self, mock_requests, mock_subprocess):
        username = 'murjax'
        repo_info_url = "https://api.github.com/users/" + username + "/repos"
        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_response.json.return_value = []
        mock_requests.get.return_value = mock_response
        github_repo_cloner.clone_handler.clone(username)
        mock_requests.get.assert_called_with(repo_info_url)
        mock_subprocess.run.assert_not_called()

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    def test_usename_null(self, mock_requests, mock_subprocess):
        username = None
        github_repo_cloner.clone_handler.clone(username)
        mock_requests.get.assert_not_called()
        mock_subprocess.run.assert_not_called()

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    def test_username_empty_string(self, mock_requests, mock_subprocess):
        username = ''
        github_repo_cloner.clone_handler.clone(username)
        mock_requests.get.assert_not_called()
        mock_subprocess.run.assert_not_called()

if __name__ == '__main__':
    unittest.main()
