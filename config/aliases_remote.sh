# -------------------------------------------------------------------
# General and Navigation
# -------------------------------------------------------------------

HOST_IP_ADDR=$(hostname -I | awk '{ print $1 }') # This gets the actual ip addr

# Misc
alias jp="jupyter lab --no-browser --ip $HOST_IP_ADDR"
alias ls='ls -hF --color' # add colors for filetype recognition
alias nv='nvidia-smi'

# -------------------------------------------------------------------
# Queue management, for SGE
# -------------------------------------------------------------------

# Short aliases
full_queue='qstat -q "aml*.q@*" -f -u \*'
alias q='qstat'
alias qtop='qalter -p 1024'
alias qq=$full_queue # Display full queue
alias gq='qstat -q aml-gpu.q -f -u \*' # Display just the gpu queues
alias gqf='qstat -q aml-gpu.q -u \* -r -F gpu | egrep -v "jobname|Master|Binding|Hard|Soft|Requested|Granted"' # Display the gpu queues, including showing the preemption state of each job
alias cq='qstat -q "aml-cpu.q@gpu*" -f -u \*' # Display just the cpu queues
alias wq="watch qstat"
alias wqq="watch $full_queue"

# Queue functions
qlogin () {
  # Function to request gpu or cpu access
  # example:
  #    qlogin 2                request 2 gpus
  #    qlogin 1 cpu            request 1 cpu slot
  #    qlogin 1 aml-gpu.q@b5   request 1 gpu on b5
  if [ "$#" -eq 1 ]; then
    /usr/bin/qlogin -now n -pe smp $1 -q aml-gpu.q -l gpu=$1 -N D_$(whoami)
  elif [ "$#" -eq 2 ]; then
    gpu_args=""
    if [ "$2" = "cpu" ]; then
      queue="aml-cpu.q"
    elif  echo "$2" | grep -q "gpu" ; then
      queue="$2"
      gpu_args="gpu=$1"
    else
      queue="$2"
    fi
    /usr/bin/qlogin -now n -pe smp $1 -q $queue -l "$gpu_args" -N D_$(whoami)
  else
    echo "Usage: qlogin <num_gpus>" >&2
    echo "Usage: qlogin <num_gpus> <queue>" >&2
    echo "Usage: qlogin <num_slots> cpu" >&2
  fi
}
qtail () {
  if [ "$#" -gt 0 ]; then
    l=$(qlog $@) && tail -f $l
  else
    echo "Usage: qtail <jobid>" >&2
    echo "Usage: qtail <array_jobid> <sub_jobid>" >&2
  fi
}
qlast () {
  # Get job_id of last running job
  job_id=$(qstat | awk '$5=="r" {print $1}' | grep -E '[0-9]' | sort -r | head -n 1)
  if [ ! -z $job_id ]; then
    echo $job_id
  else
    echo "no jobs found" >&2
  fi
}
qless () {
  less $(qlog $@)
}
qcat () {
  l=$(qlog $@) && cat $l
}
echo_if_exist() {
  [ -f $1 ] && echo $1
}
qlog () {
  # Get log path of job
  if [ "$1" = "-l" ]; then
    job_id=$(qlast)
  else
    job_id=$1
  fi
  if [ "$#" -eq 1 ]; then
    echo $(qstat -j $job_id | grep stdout_path_list | cut -d ":" -f4)
  elif [ "$#" -eq 2 ]; then
    # Array jobs are a little tricky
    log_path=$(qlog $job_id)
    base_dir=$(echo $log_path | rev | cut -d "/" -f3- | rev)
    filename=$(basename $log_path)
    # Could be a number of schemes so just try them all
    echo_if_exist ${base_dir}/log/${filename} && return 0
    echo_if_exist ${base_dir}/log/${filename%.log}${2}.log && return 0
    echo_if_exist ${base_dir}/log/${filename%.log}.${2}.log && return 0
    echo_if_exist ${base_dir}/${filename%.log}.${2}.log  && return 0
    echo_if_exist ${base_dir}/${filename%.log}${2}.log && return 0
    echo "log file for job $job_id not found" >&2 && return 1
  else
    echo "Usage: qlog <jobid>" >&2
    echo "Usage: qlog <array_jobid> <sub_jobid>" >&2
  fi
}
qdesc () {
  qstat | tail -n +3 | while read line; do
  job=$(echo $line | awk '{print $1}')
  if [[ ! $(qstat -j $job | grep "job-array tasks") ]]; then
    echo $job $(qlog $job)
  else
    qq_dir=$(qlog $job)
    job_status=$(echo $line | awk '{print $5}')
    if [ $job_status = 'r' ]; then
      sub_job=$(echo $line | awk '{print $10}')
      echo $job $sub_job $(qlog $job $sub_job)
    else
      echo $job $qq_dir $job_status
    fi
  fi
done
}

qrecycle () {
  [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qrecycle $@" || command qrecycle "$@";
}

qupdate () {
  [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qupdate"|| command qupdate ;
}

# Only way to get a gpu is via queue
if [ -z $CUDA_VISIBLE_DEVICES ]; then
  export CUDA_VISIBLE_DEVICES=
fi

# -------------------------------------------------------------------
# Cleaning processes
# -------------------------------------------------------------------

clean_vm () {
  ps -ef | grep zsh | awk '{print $2}' | xargs sudo kill
  ps -ef | grep vscode | awk '{print $2}' | xargs sudo kill
}

