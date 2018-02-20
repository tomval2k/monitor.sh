#!/usr/bin/awk -f

#-> todo: add error handling

BEGIN {
  version = "0.1";
  moduledir = "modules";
  token = "AABBCC112233";
  user = "tom";
  url = "https://127.0.0.1/update";

#-> read any supplied values from command line
  for (i in ARGV){
    if (ARGV[i] ~ /^modules.d=/ ) {
      moduledir = ARGV[i];
      gsub(/^.*=/, "", moduledir);
    }
    else if (ARGV[i] ~ /^token=/ ) {
      token = ARGV[i];
      gsub(/^.*=/, "", token);
    }
    else if (ARGV[i] ~ /^user=/ ) {
      user = ARGV[i];
      gsub(/^.*=/, "", user);
    }
    else if (ARGV[i] ~ /^url=/ ) {
      url = ARGV[i];
      gsub(/^.*=/, "", url);
    }
  }

#-> force trailing slash on directories
  sub(/[^\/]$/, "&/", moduledir);


#-> dump variables
# printf "modules.d: \t %s\n", moduledir;
# printf "token: \t\t %s\n", token;
# printf "user: \t\t %s\n", user;
# printf "url: \t\t %s\n", url;
# exit;

  cmd = "date +%s";
  cmd | getline timestamp;
  close(cmd);

#-> get list of modules
#-> note: no check here to see if executable...
  count = 0;
  cmd = "ls  " moduledir;
  while( cmd | getline line > 0 ) {
    full = moduledir line;
    cmd2 = full;
    cmd2 | getline result;
    close(cmd2);

    if (count !=0){
      output = output ", ";
    }
#   output = output "\n";
    output = output result;
    count ++;
  }
  close(cmd);

  printf "{ \"user\": \"%s\", \"auth\": \"%s\", \"update\": [%s]}\n", user, token, output;
  exit;
}
