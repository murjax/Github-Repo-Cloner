# Github-Repo-Cloner (Bash)

Clone any user's public repositories concurrently.

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

