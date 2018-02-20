#!/usr/bin/awk -f

BEGIN {
  version = "0.1";
  name = "cpu";

  cmd = "date +%s";
  cmd | getline timestamp;
  close(cmd);

  ARGV[1] = "/proc/stat"
  ARGC = 2
}

/^cpu / {
  labels[2]="user";
  labels[3]="nice";
  labels[4]="system";
  labels[5]="idle";

  for (i=0; i<=3; i++)
  {
    data = data sprintf("{ \"timestamp\": \"%d\", \"name\": \"%s\", \"value\": \"%d\" }", timestamp, labels[2+i], $(2+i));
    if ( i!=3 ){
      data = data ",";
    }
    data = data "\n";
  }
}

END {
  printf "{ \"meta\": { \"name\": \"%s\", \"version\": \"%s\" } , \"data\": [%s]}\n", name, version, data;
}
