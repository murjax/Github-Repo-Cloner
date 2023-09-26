#!/bin/bash

## Notes

# Assign value of a function to a variable in bash, this also makes a closure around an exit status or return status which allows the status to be handled
# https://stackoverflow.com/questions/1809899/how-can-i-assign-the-output-of-a-function-to-a-variable-using-bash
# `VAR=$(scan)`

# Do not use local when returning a function value because it clobers exit statuses.
# https://stackoverflow.com/a/62253721/5283424

# Interrogate json with jq
# https://stackoverflow.com/questions/33950596/iterating-through-json-array-in-shell-script
# echo "$res" | jq -c -r '.[]' | while read item; do     val=$(jq -r '.value' <<< "$item")     echo "Value: $val" done

# Wait for spawned processes doing git work to complete
# https://stackoverflow.com/a/29822046/5283424
# while ps axg | grep -vw grep | grep -w process_name > /dev/null; do sleep 1; done

# Call time on a bash function
# https://unix.stackexchange.com/a/461813/188491
# main () { echo running ... }; time main

# Check for non-null/non-zero string variable
# https://stackoverflow.com/a/3601734/5283424
# `if [ -n "$1" ]`

# Return an exit code
# https://superuser.com/a/371539/644627
# `return 1`

# Process substitution, The Bash syntax for writing to a process is >(command)
# Process substitution, The Bash syntax for tell the command interpreter to run command and make its output appear as a file is <(command) expression.

# IFS=$'\n' sets word splitting to only occur on new lines.

# The art of http scripting blog post
# https://curl.se/docs/httpscripting.html

# Parse http_status_code and http_body to two different variables
# https://superuser.com/a/1805689/644627

ask () {
  if [ -n "$1" ]
    then # non-null/non-zero string check ... aka exists!
      account_name="$1"
    else # No argument supplied
      echo "Please enter account_name (user/organization name)";
      read account_name;
      echo ;
      echo "You entered $account_name";
  fi
}

make_folder () {
  mkdir $account_name &&
  cd $account_name &&
  echo
}

check () {
  if [ -n "$1" ]
    then # non-null/non-zero string check ... aka exists!
      echo "success"
      return 0; # return success code.
    else
      # echo "error"
      return 1; # return error code.
  fi
}

handle_status_code () {
  # add http_status logic here
  # 1. if valid send to parent function
  # 2. if invalid inform the user 
  # ------> error handling messages: 
  # ---------- 1. api request limit exceeded, clone_url property will not exist.
  # ---------- 2. repository does not exist, clone url property will not exist.
  # ---------- 3. not connected to the internet. please check network connection.
  # ---------- 4. unexpected http status code, $status_code $(echo body | head -n 1)
  # ------> exit() with a code when an error occurs? Or just return empty, or return 1 and have parent program read it.?
  # ------------ winner , return 0 like is currently being done by get_repos_by_page()

  local http_status=$1
  local http_body=$2

  case $http_status in
    200)
      # echo -n "Ok. HTTP Request was successful. Status code: $http_status";
      return 0; # return success code.
      ;;
    201)
      echo -n "Created. HTTP Request was successful and, as a result, a new resource was created. Status code: $http_status";
      return 0; # return success code.
      ;;
    204)
      echo -n "No Content. Server has fulfilled the request but does not need to return information. Status code: $http_status";
      return 0; # return success code.
      ;;
    304)
      echo -n "Not Modified. Caching Resource: $http_status";
      return 0; # return success code.
      ;;
    400)
      echo -n "Bad Request. Server cannot understand and process a request due to a client error. Status code: $http_status";
      exit 1; # return error code.
      ;;
    401)
      echo -n "Unauthorized. Status code: $http_status";
      exit 1; # return error code.
      ;;
    402)
      echo -n "Server/Api, Payment Required. Status code: $http_status";
      exit 1; # return error code.
      ;;
    403)
      echo "Forbidden. Status code: $http_status";
      exit 1; # return error code.
      ;;
    404)
      echo -n "Not Found. Status code: $http_status";
      exit 1; # return error code.
      ;;
    409)
      echo -n "Conflict. Status code: $http_status";
      exit 1; # return error code.
      ;;
    410)
      echo -n "Gone/Moved perminantly. Status code: $http_status";
      exit 1; # return error code.
      ;;
    429)
      echo -n "Too Many Requests. Status code: $http_status";
      exit 1; # return error code.
      ;;
    500)
      echo -n "Internal Server Error. Status code: $http_status";
      exit 1; # return error code.
      ;;
    *)
      echo "Unknown. Please open an issue describing the error code and first line in the response. $http_status";
      echo $http_body | head -n 4;
      exit 1; # return error code.
      ;;
  esac
}

get_body_from_api_or_handle_error () {
  local page=$1;
  local URL=https://api.github.com/users/$account_name/repos?page=$page;

  # get http_status and http_body from request:
  local response="$(curl -s -w "%{http_code}\n" $URL)";

  local http_body="$(echo "$response" | sed '$d')";
  local http_status="$(echo "$response" | tail -n 1)";

  # handle api request and exit if necessary:
  handle_status_code $http_status $http_body;

  # shrink page contents to only .clone_url
  local page_content=$(echo "$http_body" | jq -c '.[]' 2>/dev/null | jq -r '.clone_url' 2>/dev/null);
  echo "$page_content";
}

get_repos_by_page () {
  local page=$1;
  # page_content cannot use local because local returns a success status and we might need an error status. https://stackoverflow.com/a/62253721/5283424
  page_content=$(get_body_from_api_or_handle_error $1) || {
    echo $page_content;
    return 1;
  }
  check $page_content &&
  {
    for url in ${page_content}; do
      echo "$url";

      # git clone does not have a rate limiting that I am aware of.
      (git clone -q $url) &> /dev/null &
    done
    echo ;

    # recurse and go to the next page number until no repos come back. This might need a delay or sleep for large accounts.
    get_repos_by_page $((page+1));
  } || return 0; # return success code regardless and let the program continue.
  unset $page_content
}

clone_repos () {
  get_repos_by_page 1;
}

wait_for_git () {
  echo -n loading;
  while
    echo -n .;
    ps e | grep -v grep | grep git > /dev/null;
  do
    sleep 1;
  done;
}

# get_body_from_api_or_handle_error
# Provide a username when running the script to bypass the ask prompt.
# example: rm -rf  murjax/; bash bash/cloner.sh murjax
ask "$@" && make_folder && clone_repos && time wait_for_git && cd ..;

