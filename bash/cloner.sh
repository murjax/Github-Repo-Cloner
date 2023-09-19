## Links

# interrogate json with jq
# https://stackoverflow.com/questions/33950596/iterating-through-json-array-in-shell-script
# echo "$res" | jq -c -r '.[]' | while read item; do     val=$(jq -r '.value' <<< "$item")     echo "Value: $val" done

# wait for spawned processes doing git work to complete
# https://stackoverflow.com/a/29822046/5283424
# while ps axg | grep -vw grep | grep -w process_name > /dev/null; do sleep 1; done

# call time on a bash function
# https://unix.stackexchange.com/a/461813/188491
# main () { echo running ... }; time main

# Check for non-null/non-zero string variable
# https://stackoverflow.com/a/3601734/5283424
# `if [ -n "$1" ]`

# Return an exit code
# https://superuser.com/a/371539/644627
# `return 1`

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
      return 0; # return something similar to an exit code.
    else
      # echo "error"
      return 1; # return something similar to an exit code.
  fi
}

get_repos_by_page () {
  local page=$1;
  # reasons the curl request to the api can fail:
  # 1. api request limit exceeded, clone_url property will not exist.
  # 2. repository does not exist, clone url property will not exist.
  local page_contents=$(curl https://api.github.com/users/$account_name/repos?page=$page | jq -c '.[]' 2>/dev/null | jq -r '.clone_url' 2>/dev/null);

  # echo $page_contents;
  check $page_contents &&
  {
    for url in ${page_contents}; do
      echo "$url";

      # git clone does not have a rate limiting that I am aware of.
      (git clone -q $url) &> /dev/null &
    done
    echo ;

    # recurse and go to the next page number until no repos come back. This might need a delay or sleep for large accounts.
    get_repos_by_page $((page+1));
  } || return 0;
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

# Provide a username when running the script to bypass the ask prompt.
# example: rm -rf  murjax/; bash bash/cloner.sh murjax
ask "$@" && make_folder && clone_repos && time wait_for_git

