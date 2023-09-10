import sys
from clone_handler import CloneHandler

if len(sys.argv) == 1:
    username = input('Please enter your Github username: ')
else:
    username = sys.argv[1]

CloneHandler(username).clone_all()
