

StatusCheck() {
  if [ $1 -eq 0 ]; then
    echo STATUS = "SUCCESS"
    else
      echo STATUS = "FAILURE"
      exit 1
  fi

}

