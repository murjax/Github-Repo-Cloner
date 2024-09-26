## Functionality Checklist for each language

After updating this document please modify the checklist here:  
https://github.com/murjax/Github-Repo-Cloner/issues/44

#### Input
- [ ] accept `user/org name` as a command line argument.
- [ ] prompt for input if no `user/org name` supplied
#### Core functionality
- [ ] contact GitHub api to list repos for page 1.
- [ ] paginate GitHub api requests to get all repos.
- [ ] clones all of the repos.
- [ ] put repos into a folder with name `user/org`.
#### Error handling
- [ ] api request limit exceeded 
- [ ] `user/org` does not exist.
- [ ] are you connected to the internet?
#### Stretch
- [ ] accept multiple usernames as a command line arguments
- [ ] ci/cd check to see if updating 
- [ ] tests for ci/cd check

## Common Use-cases:
1. Updating all of an organization projects.
- fix readmes
- check dead links
- more things related to 1 ... coming soon. 

2. Consolidate readme projects. 

