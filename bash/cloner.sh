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

first() {
  mkdir $account_name &&
  cd $account_name &&
  echo
}

second () {
  curl -s https://api.github.com/users/$account_name/repos | jq -c '.[]' |

  while read i;
  do
    val=$(jq -r '.clone_url' <<< "$i");
    (git clone -q $val) &> /dev/null & 
  done;

  echo -n loading;

  while
    echo -n .;
    ps e | grep -v grep | grep git > /dev/null;
  do
    sleep 1;
  done;

  echo ;
}

ask && first && time second

