#!/usr/bin/env bash

# Setup env vars and folders for the ctl script
# This helps keep the ctl script as readable as possible

# Usage options:
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh JOB_NAME OUTPUT_LABEL
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar foobar
# source /var/vcap/jobs/foobar/helpers/ctl_setup.sh foobar nginx

set -e # exit immediately if a simple command exits with a non-zero status

export JOB_NAME=$1
export OUTPUT_LABEL=$2

# Setup job home folder
export HOME=/var/vcap
export JOB_DIR=$HOME/jobs/$JOB_NAME
chmod 755 $JOB_DIR

# Setup log, run, store and tmp folders
export LOG_DIR=$HOME/sys/log/$JOB_NAME
export RUN_DIR=$HOME/sys/run/$JOB_NAME
export STORE_DIR=$HOME/store/$JOB_NAME
export TMP_DIR=$HOME/sys/tmp/$JOB_NAME
export TMPDIR=$TMP_DIR
for dir in $LOG_DIR $RUN_DIR $STORE_DIR $TMP_DIR
do
  mkdir -p ${dir}
  chown vcap:vcap ${dir}
  chmod 775 ${dir}
done

# Add all packages /bin & /sbin into $PATH
for package_bin_dir in $(ls -d $HOME/packages/*/*bin)
do
  export PATH=${package_bin_dir}:$PATH
done

# Add all packages /lib into $LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-''} # default to empty
for package_library_dir in $(ls -d $HOME/packages/*/lib)
do
  export LD_LIBRARY_PATH=${package_library}:$LD_LIBRARY_PATH
done

# Setup Java home and add it into $PATH
export JAVA_HOME="$HOME/packages/java7/jdk"
export PATH=$JAVA_HOME/bin:$PATH

# setup CLASSPATH for all jars/ folders within packages
export CLASSPATH=${CLASSPATH:-''} # default to empty
for package_jar_dir in $(ls -d /var/vcap/packages/*/*/*.jar)
do
  export CLASSPATH=${package_jar_dir}:$CLASSPATH
done

# Load properties
source $JOB_DIR/data/properties.sh

# Load some control helpers
source $HOME/packages/bosh-helpers/ctl_utils.sh

# Redirect output
output_label=${2:-$JOB_NAME}
redirect_output ${output_label}
