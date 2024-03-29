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
> Assign value of a function to a variable in bash, this also makes a closure around an exit status or return status which allows the status to be handled
> https://stackoverflow.com/questions/1809899/how-can-i-assign-the-output-of-a-function-to-a-variable-using-bash
> `VAR=$(scan)`

> Do not use local when returning a function value because it clobers exit statuses.
> https://stackoverflow.com/a/62253721/5283424

> Interrogate json with jq
> https://stackoverflow.com/questions/33950596/iterating-through-json-array-in-shell-script
> echo "$res" | jq -c -r '.[]' | while read item; do     val=$(jq -r '.value' <<< "$item")     echo "Value: $val" done

> Wait for spawned processes doing git work to complete
> https://stackoverflow.com/a/29822046/5283424
> while ps axg | grep -vw grep | grep -w process_name > /dev/null; do sleep 1; done

> Call time on a bash function
> https://unix.stackexchange.com/a/461813/188491
> main () { echo running ... }; time main

> Check for non-null/non-zero string variable
> https://stackoverflow.com/a/3601734/5283424
> `if [ -n "$1" ]`

> Return an exit code
> https://superuser.com/a/371539/644627
> `return 1`

> Process substitution, The Bash syntax for writing to a process is >(command)
> Process substitution, The Bash syntax for tell the command interpreter to run command and make its output appear as a file is <(command) expression.

> IFS=$'\n' sets word splitting to only occur on new lines.

> The art of http scripting blog post
> https://curl.se/docs/httpscripting.html

> Parse http_status_code and http_body to two different variables
> https://superuser.com/a/1805689/644627

> Prefer echoing to stderr instead of standout when logging. This helps you from polluting stdout which is used to send output to another program.
> echo "I will show in your terminal but will not pollute $*" >&2;
> Coffee Shop insight! From Trent!