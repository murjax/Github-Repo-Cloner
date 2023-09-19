## Links

# interogate json with jq
# https://stackoverflow.com/questions/33950596/iterating-through-json-array-in-shell-script
# echo "$res" | jq -c -r '.[]' | while read item; do     val=$(jq -r '.value' <<< "$item")     echo "Value: $val" done

# wait for spawned processes doing git work to complete
# https://stackoverflow.com/a/29822046/5283424
# while ps axg | grep -vw grep | grep -w process_name > /dev/null; do sleep 1; done

# call time on a bash function
# https://unix.stackexchange.com/a/461813/188491
# main () { echo running ... }; time main

ask() {
  echo "Please enter account_name (user/organization name)";
  read account_name;
  echo ;
  echo "You entered $account_name";
}

make_folder () {
  mkdir $account_name &&
  cd $account_name &&
  echo
}

clone_repos () {
  local pagecontents=$(curl -s https://api.github.com/users/$account_name/repos | jq -c '.[]' 2>/dev/null | jq -r '.clone_url' 2>/dev/null)
  echo $pagecontents
  for url in ${pagecontents}; do
    echo "$url"
    # (git clone -q $url) &> /dev/null &
  done

  echo -n loading;

  while
    echo -n .;
    ps e | grep -v grep | grep git > /dev/null;
  do
    sleep 1;
  done;

  echo ;
}

ask && make_folder && time clone_repos

