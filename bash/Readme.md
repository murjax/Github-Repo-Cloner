# Github-Repo-Cloner (Bash)

Clone any user's public repositories concurrently.

<img width="694" alt="Screenshot 2023-09-16 at 2 44 28 PM" src="https://github.com/murjax/Github-Repo-Cloner/assets/11463275/57683c83-5440-4b0f-a45b-e3e18eb0255b">

### Requirements
- This program was build using "GNU bash, version 3.2.57(1)-release (arm64-apple-darwin22)"
- More information available at a later date.

### Local Setup
1. Clone main project: `git clone git@github.com:murjax/Github-Repo-Cloner.git`
2. Navigate to bash project: `cd bash`

### Usage
1. Run the script `bash cloner.sh`
2. Enter account name when prompted
3. Enjoy!

### Run the script with 1 command line argument
1. Run the script `rm -rf  murjax/; bash cloner.sh murjax`

### Links for learning
> Interogate json with jq  
> https://stackoverflow.com/questions/33950596/iterating-through-json-array-in-shell-script  
> `echo "$res" | jq -c -r '.[]' | while read item; do val=$(jq -r '.value' <<< "$item"); echo "Value: $val" done`

> Wait for spawned processes doing git work to complete  
> https://stackoverflow.com/a/29822046/5283424  
> `while ps axg | grep -vw grep | grep -w process_name > /dev/null; do sleep 1; done`

> Call time on a bash function  
> https://unix.stackexchange.com/a/461813/188491  
> `main () { echo running ... }; time main`

> Check for non-null/non-zero string variable
> https://stackoverflow.com/a/3601734/5283424
> `if [ -n "$1" ]`

> Return an exit code
> https://superuser.com/a/371539/644627
> `return 1`
