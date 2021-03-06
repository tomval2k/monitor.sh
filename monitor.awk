#!/usr/bin/awk -f

function gettime(){
  cmd = "date +%s.%3N";
  cmd | getline timestamp;
  close(cmd);
  return timestamp;
}

function setvariables(){
#-> check if config file is specified
  for (i in ARGV){
    if (ARGV[i] ~ /^config=/ ){
      configfile = ARGV[i];
      gsub(/^.*=/, "", configfile);
    }
  }

#-> get values from config file specfied in script parameter
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

#-> overwrite values with any passed as script parameters
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
  version = "0.5.0";
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

#-> now run each file within directory to get output
  while( cmd | getline line > 0 ){
    fullpath = moduledir line;

    cmd2 = fullpath;
    cmd2 | getline result;
    close(cmd2);

#-> each module produces a line of text which is a valid JSON array,
#-> so shall remove start and end curly brackets
    gsub(/^{|}$/, "", result);


#-> need a comma after each object except the last
    if (count !=0){
      output = output ", ";
    }
    output = output result;
    count ++;
  }
  close(cmd);

  timeend=gettime();
  timeduration=(timeend - timestart);

  printf "{ \"meta\" : { \"user\": \"%s\", \"auth\": \"%s\", \"start\": \"%.3f\", \"end\": \"%.3f\", \"duration\": \"%.3f\" }, \"records\": {%s} }\n", user, token, timestart, timeend, timeduration, output;
  exit;
}
