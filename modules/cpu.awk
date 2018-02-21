#!/usr/bin/awk -f

BEGIN {
  version = "0.2.0";
  name = "cpu";

  cmd = "date +%s";
  cmd | getline timestamp;
  close(cmd);

  ARGV[1] = "/proc/stat";
  ARGC = 2;

  data[2,0]="user";
  data[3,0]="nice";
  data[4,0]="system";
  data[5,0]="idle";
}

/^cpu / {
  data[2,1]=$2;
  data[3,1]=$3;
  data[4,1]=$4;
  data[5,1]=$5;
}

END {
  for (i=0; i<=3; i++)
  {
    output = output sprintf("  \"%s\" : { \"timestamp\": \"%d\", \"value\": \"%d\" }", data[2+i,0], timestamp, data[2+i,1]);
    if ( i!=3 ){
      output = output sprintf( ",");
    }
  }
  printf "{ \"mod-%s\": { \"meta\": {\"name\": \"%s\",\"version\": \"%s\"},\"data\": {%s} } }\n", name, name, version, output;
}
