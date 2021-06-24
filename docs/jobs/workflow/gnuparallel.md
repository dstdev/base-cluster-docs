# GNU Parallel

[GNU Parallel](https://www.gnu.org/software/parallel/) is a free, open-source
tool for running shell commands and scripts in parallel and sequence on a
single node.

A workflow pattern with the following characteristics is a good match for GNU
parallel:

* Individual tasks do not use MPI or multiple nodes.
* Contains many similar tasks with no execution order requirements or data
  dependencies.

## Strengths of GNU Parallel:

* No user installation or configuration
* No databases or persistent manager process
* Easily scales to a very large number of tasks
* Easily scales to multiple nodes
* Efficient use of scheduler resources

## Disadvantages of GNU Parallel:

* Doesn't easily balance work amongst multiple nodes
* User is required to do careful organization of input and output files
* Scaling up requires consideration of system I/O performance
* Modest familiarity with bash scripting recommended

## How to use GNU Parallel at NERSC

In this first example, `seq` is used to generate four lines of input, which is
piped into `parallel`. Those four input lines cause `parallel` to run four
tasks in total. Then the command each task will run is passed to `parallel`, in
this case, `echo` and its arguments. The `{}` in the command sets a location
where individual input line content will be substituted inside each task
command.

??? note "Basic example"
    ```
    elvis@cori04:~> module load parallel
    elvis@cori04:~> seq 1 4 | parallel echo "Hello world {}!"
    Hello world 1!
    Hello world 2!
    Hello world 3!
    Hello world 4!
    elvis@cori04:~>
    ```

The next necessary concept is how to submit substantial tasks and input files
to `parallel`. This example shows how input data created with sequential
file names can be passed to parallel using bash commands and pipes:

??? note "Sequentially named input files for each task"
    ```
    elvis@nid00050:~/work> ls
    input01.dat  input02.dat  input03.dat  input04.dat  input05.dat
    input06.dat  input07.dat  input08.dat  input09.dat  input10.dat
    elvis@nid00050:~/work> seq -w 1 10 | parallel task_command.sh input{}.dat
    ```
    This example occurs in an `salloc` session. Though `parallel` is great for
    automating mundane repetitive tasks like creating many directories or
    parsing lots of log files, tasks which use a substantial amount of
    compute resources still need to be run on Slurm allocated compute nodes
    and not on shared login nodes.

A second approach places all task inputs into the same directory and uses the
`find` command to build the file listing all their paths:

??? note "Using `find` to build an input file list"
    ```
    elvis@nid00050:~/work> find $PWD -type f | grep dat | sort > input.txt
    elvis@nid00050:~/work> cat input.txt | parallel task_command.sh {}
    ```

??? warning "I/O Performance Pitfalls at Large Scale"
    If work requires large numbers (more than 1000) of tasks and input files
    then some extra precautions should be taken to avoid I/O scaling
    bottlenecks.

    Use subdirectories to prevent a single folder from containing more than
    1000 files or directories.

    At larger scale it is more important to use higher performance file systems
    such as Cori Lustre or the Burst Buffer to read and write data. 

    If all of your tasks are reading the same files then you can increase
    performance by making multiple copies of those files and assigning
    different tasks to read different copies.

### Running Many Tasks Inside a Single Node Allocation

This Slurm batch script will request one KNL node in the regular QOS and then
run `parallel` on that node. The `parallel` command runs up six tasks of
`task_command.sh` at a time, one for each line in the file
`input.txt`. If the input file contains more than six lines
then the additional tasks will wait until earlier tasks finish and space
is available for them. Each input line string becomes an argument to its task
script.

??? note "single_node_many_task_with_parallel.sh"
    ```
    #!/bin/bash
    #SBATCH --qos=regular
    #SBATCH --Nodes=1
    #SBATCH --constraint=knl

    module load parallel

    srun parallel --jobs 6 task_command.sh argument_{} < input.txt 
    ```

This arrangement is a great alternative to submitting many individual jobs or
a task array to the shared Slurm QOS. Current scheduling policy only allows two
jobs per user to gain priority at a time; a single job running many tasks will
spend less time waiting in queue than many jobs each running a single task.
Also, this work pattern requires much less interaction with the Slurm
controller, which makes it less likely to cause or be impacted by the Slurm
controller experiencing heavy load. 

### Many Tasks Inside a Multiple Node Allocation

Demonstrated using two scripts: a batch submission to Slurm and a payload
script containing the parallel and task commands.

This batch submission will request two KNL nodes, then the `srun` will run two
instances of `payload.sh` with the `$1` argument containing the task input
list.

??? note "multiple_nodes_many_tasks_parallel.sh"
    ```
    #!/bin/bash
    #SBATCH --qos=regular
    #SBATCH --Nodes=2
    #SBATCH --constraint=knl
    #SBATCH --ntasks-per-node 1

    srun --no-kill --ntasks=2 --wait=0 payload.sh $1 
    ```

    The `--no-kill` argument will keep the slurm allocation running if any of
    the allocated nodes fail during the job. The `--wait=0` argument prevents
    the job from terminating the other payload instances when the first one
    finishes.

The payload script uses environment variables set by Slurm inside a job to
distinguish each instance of parallel, and then round-robin distributes input
tasks to them using `awk`.

??? note "payload.sh"
    ```
    #!/bin/bash
    module load parallel
    if [[ -z "${SLURM_NODEID}" ]]; then
        echo "need \$SLURM_NODEID set"
        exit
    fi
    if [[ -z "${SLURM_NNODES}" ]]; then
        echo "need \$SLURM_NNODES set"
        exit
    fi
    cat $1 |                                               \
    awk -v NNODE="$SLURM_NNODES" -v NODEID="$SLURM_NODEID" \
    'NR % NNODE == NODEID' |                               \
    parallel task.sh {}
    ```

    The conditional statements make sure the Slurm environment variables we
    need are in place. `$SLURM_NNODES` holds the total number of nodes in the
    job and `$SLURM_NODEID` holds the unique ID number of _this_ node. The
    `awk` command uses the line number of each input and the two environment
    variables to implement round-robin assignments of tasks to nodes. An
    advantage of this method is the number of nodes requested by the job can be
    freely changed without needing to adjust the task-to-node assignment logic.

### Scaling Parallel with `--sshlogin` is Not Recommended

GNU parallel includes a feature to distribute tasks to multiple machines using
ssh connections. Though this allows work to balance between multiple nodes, our
testing suggests that scaling is much less effective and it would be better to
use a different task manager. More detail about this finding is available upon
request.

### Resuming Unfinished or Retrying Failed Tasks
 
If any tasks in a GNU parallel instance return a non-zero exit code, the
parallel will also return non-zero. Parallel can be configured to use a job
log file which tracks failed or incomplete tasks so that they can be resumed or
retried.

Add `--resume-failed --joblog logfile.txt` to the list of parallel arguments
and the state of tasks will be recorded. When that parallel instance is rerun
with the exact same command line, it will skip any tasks that are already
complete and re-run any tasks which failed. When using joblog it is good
practice to use the available Slurm environment variables to distinguish
files for each instance of `parallel`.

It is very important that the input file and command line arguments not be
modified between runs and that only one instance of parallel per log file run
at a time.

Note that the `--retries n` parallel argument _seems_ like it should allow
an instance of `parallel` to retry a failed task, but actually, this feature
only works when using the `--sshlogin` feature.
