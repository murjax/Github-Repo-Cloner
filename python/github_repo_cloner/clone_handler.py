"""Module for CloneHandler class"""
import subprocess
import math
import requests

class CloneHandler:
    """Github Clone Handler"""
    PER_PAGE = 30.0
    BASE_URL = 'https://api.github.com'

    def __init__(self, username):
        self.username = username
        self.user_info = {}
        self.repo_info = []
        self.errors = []

    def clone_all(self):
        """Clone all repositories for username"""
        self.__validate_username()
        self.__get_info()
        self.__validate_info()
        if len(self.errors) > 0:
            self.__print_errors()
            return False

        subprocess.run(self.__final_command(), shell=True, check=False)
        return True

    # Private methods

    def __final_command(self):
        return ' & '.join(self.__get_clone_commands())

    def __get_clone_commands(self):
        if len(self.repo_info) == 0:
            return []

        return map(self.__build_repo_clone_command, self.repo_info)

    def __build_repo_clone_command(self, info):
        return f"git clone {info['clone_url']} {self.username}/{info['name']}"

    def __page_count(self):
        repo_count = self.user_info.get('public_repos', 0)
        return math.ceil(repo_count / self.PER_PAGE)

    def __get_repo_info_for_page(self, page):
        response = requests.get(f'{self.BASE_URL}/users/{self.username}/repos?page={page}')
        return response.json()

    def __get_info(self):
        self.__get_user_info()
        self.__get_repo_info()

    def __get_user_info(self):
        if len(self.errors) > 0:
            return

        try:
            response = requests.get(f'{self.BASE_URL}/users/{self.username}')
            self.user_info = response.json()
        except OSError:
            self.user_info = { 'message': 'Network error' }

    def __get_repo_info(self):
        if len(self.errors) > 0:
            return

        for page in range(1, self.__page_count() + 1):
            info = self.__get_repo_info_for_page(page)
            if isinstance(info, list):
                self.repo_info.extend(info)
            elif isinstance(info, dict):
                self.repo_info.append(info)

    def __validate_clonable(self):
        self.__validate_username()
        self.__validate_user_info()
        self.__validate_repo_info()

    def __validate_username(self):
        if self.username in (None, ''):
            self.errors.append('No username provided')

    def __validate_info(self):
        self.__validate_user_info()
        self.__validate_repo_info()

    def __validate_user_info(self):
        if len(self.errors) > 0:
            return

        error_message = self.user_info.get('message')
        if error_message == 'Not Found':
            self.errors.append('Account does not exist')
        elif error_message and 'API rate limit exceeded' in error_message:
            self.errors.append('API rate limit exceeded')
        elif error_message and 'Network error' in error_message:
            self.errors.append('Network error')
        elif self.user_info.get('public_repos', 0) == 0:
            self.errors.append('No repositories found at this account')

    def __validate_repo_info(self):
        if len(self.errors) > 0:
            return

        for info in self.repo_info:
            error_message = info.get('message')
            if error_message and 'API rate limit exceeded' in error_message:
                self.errors.append('API rate limit exceeded')

    def __print_errors(self):
        for error in self.errors:
            print(error)
