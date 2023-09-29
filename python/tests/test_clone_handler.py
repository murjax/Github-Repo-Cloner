import unittest
from unittest.mock import MagicMock, patch
import io
import sys
import requests
from github_repo_cloner.clone_handler import CloneHandler

class TestCloneHandler(unittest.TestCase):
    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    @patch('github_repo_cloner.clone_handler.CloneHandler.PER_PAGE', 2.0)
    def test_success_one_page(self, mock_requests, mock_subprocess):
        username = 'murjax'
        name1 = 'spring_engine'
        name2 = 'burger_bot'
        user_info_url = f'https://api.github.com/users/{username}'
        page1_info_url = f'{user_info_url}/repos?page=1'
        clone_url1 = f'https://github.com/{username}/{name1}.git'
        clone_url2 = f'https://github.com/{username}/{name2}.git'
        command1 = f'git clone {clone_url1} {username}/{name1}'
        command2 = f'git clone {clone_url2} {username}/{name2}'
        final_command = command1 + ' & ' + command2
        user_info_response = { 'public_repos': 2 }
        page1_response = [
            { 'name': name1, 'clone_url': clone_url1 },
            { 'name': name2, 'clone_url': clone_url2 }
        ]

        user_info_mock_response = MagicMock()
        user_info_mock_response.status_code = 200
        user_info_mock_response.json.return_value = user_info_response

        page1_mock_response = MagicMock()
        page1_mock_response.status_code = 200
        page1_mock_response.json.return_value = page1_response

        mock_requests.get.side_effect = [user_info_mock_response, page1_mock_response]

        result = CloneHandler(username).clone_all()

        self.assertEqual(result, True)
        mock_subprocess.run.assert_called_with(final_command, shell=True, check=False)

        mock_requests.get.assert_has_calls([
            unittest.mock.call(user_info_url),
            unittest.mock.call(page1_info_url)
        ])

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    @patch('github_repo_cloner.clone_handler.CloneHandler.PER_PAGE', 2.0)
    def test_success_two_pages(self, mock_requests, mock_subprocess):
        username = 'murjax'
        name1 = 'spring_engine'
        name2 = 'burger_bot'
        name3 = 'wicked_pdf_capybara'
        user_info_url = f'https://api.github.com/users/{username}'
        page1_info_url = f'{user_info_url}/repos?page=1'
        page2_info_url = f'{user_info_url}/repos?page=2'
        clone_url1 = f'https://github.com/{username}/{name1}.git'
        clone_url2 = f'https://github.com/{username}/{name2}.git'
        clone_url3 = f'https://github.com/{username}/{name3}.git'
        command1 = f'git clone {clone_url1} {username}/{name1}'
        command2 = f'git clone {clone_url2} {username}/{name2}'
        command3 = f'git clone {clone_url3} {username}/{name3}'
        final_command = command1 + ' & ' + command2 + ' & ' + command3
        user_info_response = { 'public_repos': 3 }
        page1_response = [
            { 'name': name1, 'clone_url': clone_url1 },
            { 'name': name2, 'clone_url': clone_url2 }
        ]
        page2_response = [
            { 'name': name3, 'clone_url': clone_url3 }
        ]

        user_info_mock_response = MagicMock()
        user_info_mock_response.status_code = 200
        user_info_mock_response.json.return_value = user_info_response

        page1_mock_response = MagicMock()
        page1_mock_response.status_code = 200
        page1_mock_response.json.return_value = page1_response

        page2_mock_response = MagicMock()
        page2_mock_response.status_code = 200
        page2_mock_response.json.return_value = page2_response

        mock_requests.get.side_effect = [
            user_info_mock_response,
            page1_mock_response,
            page2_mock_response
        ]

        result = CloneHandler(username).clone_all()

        self.assertEqual(result, True)
        mock_subprocess.run.assert_called_with(final_command, shell=True, check=False)

        mock_requests.get.assert_has_calls([
            unittest.mock.call(user_info_url),
            unittest.mock.call(page1_info_url),
            unittest.mock.call(page2_info_url)
        ])

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    @patch('github_repo_cloner.clone_handler.CloneHandler.PER_PAGE', 2.0)
    def test_no_repos(self, mock_requests, mock_subprocess):
        username = 'murjax'
        user_info_url = f'https://api.github.com/users/{username}'
        user_info_response = { 'public_repos': 0 }
        error_message = 'No repositories found at this account'

        user_info_mock_response = MagicMock()
        user_info_mock_response.status_code = 200
        user_info_mock_response.json.return_value = user_info_response

        mock_requests.get.return_value = user_info_mock_response

        output = io.StringIO()
        sys.stdout = output

        result = CloneHandler(username).clone_all()

        sys.stdout = sys.__stdout__

        self.assertEqual(result, False)
        self.assertEqual(output.getvalue().strip(), error_message)
        mock_requests.get.assert_called_once_with(user_info_url)
        mock_subprocess.run.assert_not_called()

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    @patch('github_repo_cloner.clone_handler.CloneHandler.PER_PAGE', 2.0)
    def test_username_not_found(self, mock_requests, mock_subprocess):
        username = 'murjax'
        user_info_url = f'https://api.github.com/users/{username}'
        user_info_response = { 'message': 'Not Found' }
        error_message = 'Account does not exist'

        user_info_mock_response = MagicMock()
        user_info_mock_response.status_code = 404
        user_info_mock_response.json.return_value = user_info_response

        mock_requests.get.return_value = user_info_mock_response

        output = io.StringIO()
        sys.stdout = output

        result = CloneHandler(username).clone_all()

        sys.stdout = sys.__stdout__

        self.assertEqual(result, False)
        self.assertEqual(output.getvalue().strip(), error_message)
        mock_requests.get.assert_called_once_with(user_info_url)
        mock_subprocess.run.assert_not_called()

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    @patch('github_repo_cloner.clone_handler.CloneHandler.PER_PAGE', 2.0)
    def test_username_null(self, mock_requests, mock_subprocess):
        error_message = 'No username provided'

        output = io.StringIO()
        sys.stdout = output

        result = CloneHandler(None).clone_all()

        sys.stdout = sys.__stdout__

        self.assertEqual(result, False)
        self.assertEqual(output.getvalue().strip(), error_message)
        mock_requests.get.assert_not_called()
        mock_subprocess.run.assert_not_called()

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    @patch('github_repo_cloner.clone_handler.CloneHandler.PER_PAGE', 2.0)
    def test_username_empty_string(self, mock_requests, mock_subprocess):
        error_message = 'No username provided'

        output = io.StringIO()
        sys.stdout = output

        result = CloneHandler('').clone_all()

        sys.stdout = sys.__stdout__

        self.assertEqual(result, False)
        self.assertEqual(output.getvalue().strip(), error_message)
        mock_requests.get.assert_not_called()
        mock_subprocess.run.assert_not_called()

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    @patch('github_repo_cloner.clone_handler.CloneHandler.PER_PAGE', 2.0)
    def test_network_error(self, mock_requests, mock_subprocess):
        username = 'murjax'
        user_info_url = f'https://api.github.com/users/{username}'
        mock_requests.get.side_effect = requests.exceptions.ConnectionError('Connection error')
        error_message = 'Network error'

        output = io.StringIO()
        sys.stdout = output

        result = CloneHandler(username).clone_all()

        sys.stdout = sys.__stdout__

        self.assertEqual(result, False)
        self.assertEqual(output.getvalue().strip(), error_message)
        mock_requests.get.assert_called_once_with(user_info_url)
        mock_subprocess.run.assert_not_called()

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    @patch('github_repo_cloner.clone_handler.CloneHandler.PER_PAGE', 2.0)
    def test_api_rate_limit_exceeded_user_request(self, mock_requests, mock_subprocess):
        username = 'murjax'
        user_info_url = f'https://api.github.com/users/{username}'
        user_info_response = { 'message': 'API rate limit exceeded for user' }
        error_message = 'API rate limit exceeded'

        user_info_mock_response = MagicMock()
        user_info_mock_response.status_code = 403
        user_info_mock_response.json.return_value = user_info_response
        mock_requests.get.return_value = user_info_mock_response

        output = io.StringIO()
        sys.stdout = output

        result = CloneHandler(username).clone_all()

        sys.stdout = sys.__stdout__

        self.assertEqual(result, False)
        self.assertEqual(output.getvalue().strip(), error_message)
        mock_requests.get.assert_called_once_with(user_info_url)
        mock_subprocess.run.assert_not_called()

    @patch('github_repo_cloner.clone_handler.subprocess')
    @patch('github_repo_cloner.clone_handler.requests')
    @patch('github_repo_cloner.clone_handler.CloneHandler.PER_PAGE', 2.0)
    def test_api_rate_limit_exceeded_repo_request(self, mock_requests, mock_subprocess):
        username = 'murjax'
        user_info_url = f'https://api.github.com/users/{username}'
        page1_info_url = f'{user_info_url}/repos?page=1'
        user_info_response = { 'public_repos': 2 }
        page1_response = { 'message': 'API rate limit exceeded for user' }

        error_message = 'API rate limit exceeded'

        user_info_mock_response = MagicMock()
        user_info_mock_response.status_code = 200
        user_info_mock_response.json.return_value = user_info_response

        page1_mock_response = MagicMock()
        page1_mock_response.status_code = 403
        page1_mock_response.json.return_value = page1_response

        mock_requests.get.side_effect = [user_info_mock_response, page1_mock_response]

        output = io.StringIO()
        sys.stdout = output

        result = CloneHandler(username).clone_all()

        sys.stdout = sys.__stdout__

        self.assertEqual(result, False)
        self.assertEqual(output.getvalue().strip(), error_message)
        mock_requests.get.assert_has_calls([
            unittest.mock.call(user_info_url),
            unittest.mock.call(page1_info_url)
        ])
        mock_subprocess.run.assert_not_called()
