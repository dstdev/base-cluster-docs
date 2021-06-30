# Slurm

!!! warning
    This page is currently under active development. Check
    back soon for more content.


## Additional Resources

- Documentation: https://slurm.schedmd.com/documentation.html
- Tutorial: https://slurm.schedmd.com/tutorials.html
- Manual: https://slurm.schedmd.com/man_index.html
- FAQ: https://slurm.schedmd.com/faq.html

## Jobs

A **job** is an allocation of resources such as compute nodes assigned
to a user for an amount of time. Jobs can be interactive or batch
(e.g., a script) scheduled for later execution.

!!! tip

Once a job is assigned a set of nodes, the user is able to initiate
parallel work in the form of job steps (sets of tasks) in any
configuration within the allocation.


## Submitting jobs

### sbatch

`sbatch` is used to submit a job script for later execution. The
script will typically contain one or more `srun` commands to launch
parallel tasks.

When you submit the job, Slurm responds with the job's ID, which will
be used to identify this job in reports from Slurm.

```console
$ sbatch first-job.sh
Submitted batch job 864933
```

Slurm will also check your file system usage and reject the job if
you are over your quota in your scratch or home file system. See
[here](#quota-enforcement) for more details.

### salloc

`salloc` is used to allocate resources for a job in real time as an
[interactive batch job](interactive.md). Typically this is used to
allocate resources and spawn a shell. The shell is then used to
execute `srun` commands to launch parallel tasks.

### srun

`srun` is used to submit a job for execution or initiate job steps in
real time. A job can contain multiple job steps executing sequentially
or in parallel on independent or shared resources within the job's
node allocation. This command is typically executed within a script
which is submitted with `sbatch` or from an interactive prompt on a
compute node obtained via `salloc`.

### Options

At a minimum a job script must include number of nodes, time, type
of nodes (constraint), quality of service (QOS), and on Perlmutter,
the number of GPUs. If a script does not specify any of these options
then a default may be applied.

!!! tip
    It is good practice to always set the account option
    (`--account=<NERSC Project>`).


The full list of directives is documented in the man pages for the
`sbatch` command (see `man sbatch`). Each option can be specified
either as a directive in the job script:

```slurm
#!/bin/bash
#SBATCH -N 2
```

Or as a command line option when submitting the script:

```bash
sbatch -N 2 ./first-job.sh
```

The command line and directive versions of an option are equivalent
and interchangeable. If the same option is present both on the command
line and as a directive, the command line will be honored. If the same
option or directive is specified twice, the last value supplied will
be used.

Also, many options have both a long form, e.g., `--nodes=2` and a short
form, e.g., `-N 2`. These are equivalent and interchangable.

Many options are common to both `sbatch` and `srun`, for example
`sbatch -N 4 ./first-job.sh` allocates 4 nodes to `first-job.sh`, and
`srun -N 4 uname -n` inside the job runs a copy of `uname -n` on each
of 4 nodes. If you don't specify an option in the `srun` command line,
`srun` will inherit the value of that option from `sbatch`.

In these cases the default behavior of `srun` is to assume the same
options as were passed to `sbatch`. This is achieved via environment
variables: `sbatch` sets a number of environment variables with
names like `SLURM_JOB_NUM_NODES` and srun checks the values of those
variables. This has two important consequences:

1. Your job script can see the settings it was submitted with by
   checking these environment variables

2. You should not override these environment variables. Also be aware
   that if your job script does certain tricky things, such as using
   ssh to launch a command on another node, the environment might not
   be propagated and your job may not behave correctly

#### Commonly Used Options

The below table lists some commonly used `sbatch`/`salloc`/`srun`
options as well as their meaning. All the listed options can be
used with the `sbatch` or `salloc` commands (either on the
command line or as directives within a script). Many are also
commonly used with `srun` within a script or interactive job.

The long and short forms of each option are interchangeable, but their
formats differ. The long form begins with a double hyphen and includes
a word, acronym, or phrase (with words separated by single hyphens)
followed by an equals sign and any argument to the option (e.g.,
`--time=10:00:00`) while the short form consists a single hyphen and a
single letter, followed by a space and any argument to the option
(e.g., `-t 10:00:00`). For clarity, we recommend using the long form
for Slurm directives in a script -- this makes it easier to understand
what options are being set on each line.

| Option (long form) | Option (short form) | Meaning            | Use with sbatch/salloc?  | Use with srun? |
|--------------------|---------------------|--------------------|--------------------------|----------------|
| `--time`           | `-t`                | maximum walltime   | Y                        | N              |
| `--time-min`       |  (none)             | minimum walltime   | Y                        | N              |
| `--nodes`          | `-N`                | number of nodes    | Y                        | Y              |
| `--ntasks`         | `-n`                | number of MPI tasks | Y                       | Y              |
| `--cpus-per-task`  | `-c`                | number of processors per MPI task | Y         | Y              |
| `--gpus`           | `-G`                | total number of GPUs (Perlmutter) | Y         | Y              |
| `--gpus-per-node`  | (none)              | number of GPUs per node (Perlmutter) | Y         | Y              |
| `--gpus-per-task`  | (none)              | number of GPUs per MPI task (Perlmutter) | Y         | Y              |
| `--constraint`     | `-C`                | constraint (e.g., type of resource) | Y       | N              |
| `--qos`            | `-q`                | quality of service (QOS) | Y                  | N              |
| `--account`        | `-A`                | project to charge for this job | Y            | N              |
| `--licenses`       | `-L`                | licenses (filesystem required for job) | Y    | N              |
| `--job-name`       | `-J`                | name of job        | Y                        | N              |

#### Writing a Job Script

A clear job script will include at least the number of nodes,
walltime, type of nodes (constraint), quality of service (QOS),
and, on Perlmutter, the number of GPUs. These options could be
specified on the command line, but for clarity and to establish a
record of the job submission we recommend including all these options
(and more) in your job script.

A Slurm job script begins with a shell invocation (e.g.,
`#!/bin/bash`) followed by lines of directives, each of which begins
with `#SBATCH`.  After these directives, users then include the
commands to be run in the script, including the setting of environment
variables and the setup of the job. Usually (but not always) the
script includes at least one `srun` command, launching a parallel job
onto one or more nodes allocated to the job.

```slurm
#!/bin/bash
#SBATCH --nodes=<nnodes>
#SBATCH --time=hh:mm:ss
#SBATCH --constraint=<architecture>
#SBATCH --qos=<QOS>
#SBATCH --account=<project_name>

# set up for problem & define any environment variables here

srun -n <num_mpi_processes> -c <cpus_per_task> a.out

# perform any cleanup or short post-processing here
```

The above script is easily applied only to the simplest of cases and
is not widely generalizable. In this simple case, a user would replace
the items between `< >` with specific arguments, e.g., `--nodes=2` or
`--qos=debug`. The format for the maximum walltime request is number
of hours, number of minutes, and number of seconds, separated by
colons (e.g., `--time=12:34:56` for 12 hours, 34 minutes, and 56
seconds).

There are many factors to consider when creating a script for your
particular job. In our experience, we find that determining the
correct settings for number of CPUs per task, [process
affinity](affinity/index.md), etc. can be tricky. Consequently, we
recommend using the [Job Script

The job script generator will provide the correct runtime arguments
for your job, but may not adequately demonstrate a way to run jobs
that fits your particular workflow or application. To help with this,
we have developed a curated collection of [example job
scripts](examples/index.md) for users to peruse for inspiration.

#### Defaults

If you do not specify the following options in your script, defaults
will be assigned.

| Option     | Cori         | Perlmutter   |
|------------|--------------|--------------|
| nodes      | 1            | 1            |
| time       | 10 minutes   | 5 minutes    |
| qos        | debug        | regular      |
| account    | set in Iris  | set in Iris  |

!!! alert "There is no default architecture"
    Jobs not specifying the "constraint" will be rejected.

### Debugging issues

If there are issues with job submission check:

* all required options are set
* selected options match [queue policy](policy.md)
* appropriate [modules](../environment/modules.md) are loaded
* your compliance with [quota](#quota-enforcement)

## Available memory for applications on compute nodes

Some memory on compute nodes is reserved for the operating system.

| Node Type      | Total Memory (GB)  | Available to Applications (GB) |
|----------------|--------------------|---------------------------|
| Perlmutter GPU | CPU: 256, GPU: 160 | TBA                       |
| Cori Haswell   | 128                | 118                       |
| Cori KNL       | 96                 | 87                        |

## Quota Enforcement

Users will not be allowed to submit jobs if they are over quota in
their scratch or home directories. This quota check is performed
twice, first when the job is submitted and again when the running job
invokes `srun`. This could mean that if you went over quota after
submitting the job, the job could fail when it runs. Please [check
your quota](../filesystems/quotas.md) regularly and delete or
archive data as needed.

## Queue Wait Times


## Further reading about jobs

* [Interactive](interactive.md) jobs
* [I/O Performance](../performance/io/index.md)
* [Example jobs (Cori)](examples/index.md)
* [Monitoring](monitoring.md) jobs
* [Best Practices](best-practices.md) for jobs
* [Troubleshooting Slurm](troubleshooting.md)

## Additional Constraints

Currently it is not possible for users to run a single job which
includes multiple types of nodes (e.g., Cori Haswell and KNL nodes
in a single job).
