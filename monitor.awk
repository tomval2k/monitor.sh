#!/usr/bin/awk -f

#-> todo: add error handling

function gettime(){
  cmd = "date +%s";
  cmd | getline timestamp;
  close(cmd);
  return timestamp;
}

#-> read any supplied values from command line
#-> config read from config file if specified, and overwritten with supplied arguments
function setvariables(){
#-> check if config file is specified
  for (i in ARGV){
    if (ARGV[i] ~ /^configfile=/ ){
      configfile = ARGV[i];
      gsub(/^.*=/, "", configfile);
    }
  }

#-> get values from config file
  while( (getline line < configfile) > 0){
    print "x: " line;
    if (line ~ /^modules.d=/ ){
      moduledir = line;
    }
    else if (line ~ /^token=/ ){
      token = line;
    }
    else if (line ~ /^user=/ ){
      user = line;
    }
    else if (line ~ /^url=/ ){
      url = line;
    }
  }

#-> overwrite values with any parameters passed to script
  for (i in ARGV){
    if (ARGV[i] ~ /^modules.d=/ ){
      moduledir = ARGV[i];
    }
    else if (ARGV[i] ~ /^token=/ ){
      token = ARGV[i];
    }
    else if (ARGV[i] ~ /^user=/ ){
      user = ARGV[i];
    }
    else if (ARGV[i] ~ /^url=/ ){
      url = ARGV[i];
    }
  }

#-> abc=[VALUE] -> [VALUE]
  gsub(/^.*=/, "", moduledir);
  gsub(/^.*=/, "", token);
  gsub(/^.*=/, "", user);
  gsub(/^.*=/, "", url);

#-> force trailing slash on directories
  sub(/[^\/]$/, "&/", moduledir);
}


#-> dump variables
function getvariables(){
  printf "--------------------------------------------------\n";
  printf "config file: \t %s\n", configfile;
  printf "modules.d: \t %s\n", moduledir;
  printf "token: \t\t %s\n", token;
  printf "user: \t\t %s\n", user;
  printf "url: \t\t %s\n", url;
  printf "--------------------------------------------------\n";
}

BEGIN {
  version = "0.1";
  moduledir = "modules";
# token = "AABBCC112233";
  user = "tom";
  url = "https://127.0.0.1/update";

  timestart=gettime();
  setvariables();
# getvariables();


#-> get list of modules
#-> note: no check here to see if executable...
  count = 0;
  cmd = "ls  " moduledir;

#-> check directory exists
  result=system(cmd " > /dev/null 2>&1");

  if (result != 0){
    printf "ERROR: '%s' returned error code '%d'\n", cmd, result;
    exit 1;
  }

  while( cmd | getline line > 0 ){
    fullpath = moduledir line;

    cmd2 = fullpath;
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


  timeend=gettime();


  printf "{ \"user\": \"%s\", \"auth\": \"%s\", \"timestart\": \"%d\", \"timeend\": \"%d\", \"update\": [%s]}\n", user, token, timestart, timeend, output;


  exit;
}
