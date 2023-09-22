import unittest
from unittest.mock import patch
from github_repo_cloner import clone_all_handler

class TestCloneAllHandler(unittest.TestCase):
    @patch(
        'clone_page_handler.clone',
        side_effect=[True, True, False]
    )
    def test_clone_each_page(self, mock_page_cloner):
        username = 'murjax'
        clone_all_handler.clone_all(username)
        self.assertEqual(mock_page_cloner.call_count, 3)

if __name__ == '__main__':
    unittest.main()
