# Best Practices for Jobs

## Do Not Run Production Jobs in Global Homes

As a general best practice, users should do production runs from
`$SCRATCH` instead of `$HOME`.

`$HOME` is meant for permanent and relatively small storage. It is not
tuned to perform well for parallel jobs. Home is perfect for storing
files such as source codes and shell scripts, etc. Please note that
while building software in /global/home is generally good, it is best
to install dynamic libraries that are used on compute nodes
in [global common](../../filesystems/global-common) for best
performance.

`$SCRATCH` is meant for large and temporary storage. It is optimized
for read and write operations. `$SCRATCH` is perfect for staging data
and performing parallel computations.  Running in `$SCRATCH` also helps
to improve the responsiveness of the global file systems (global homes
and global project) in general.

## Specify account


## Time Limits

Due to backfill scheduling, short and variable-length jobs generally
start quickly resulting in much better job throughput.

```slurm
#SBATCH --time-min=<lower_bound>
#SBATCH --time=<upper_bound>
```

## Long Running Jobs

Simulations which must run for a long period of time achieve the best
throughput when composed of many small jobs utilizing
checkpoint/restart chained together.

* [Example: job chaining](examples/index.md#dependencies)

## Improve Efficiency by Preparing User Environment Before Running

In general, compute nodes are optimized for processing data and running
simulations. Users should use login nodes for compilations, environment
setup and preprocessing small inputs, in order to utilize compute
resources efficiently.

Using the [Linux here document](https://en.wikipedia.org/wiki/Here_document)
as in the example below will run those commands to prepare the user
environment for the batch job on the login node to help improve job efficiency
and save computing cost of the batch job. It can also help to alleviate the
burden on the global home file system. This script also keeps the user
environment needed for the batch job in a single file.

!!! Example
    This is an example of a script to prepare the user environment on a login
    node, propagate this environment to a batch job, and submit the batch job.
    This can be accomplished in a single script.

    You could do so by preparing a file named `prepare-env.sh` in the example
    below, and running it as `./prepare-env.sh` on a login node. This script:

    * Sets up the user environment for the batch job first on a login node,
      such as loading modules, setting environment variables, or copying input
      files, etc.;
    * Creates a batch script named `prepare-env.sl`;
    * Submits `prepare-env.sl`: this job will inherit the user environment
      just set earlier in the script.

```
--8<-- "docs/jobs/examples/prepare-env/prepare-env.sh"
```

## I/O Performance

Cori has dedicated large, local, parallel scratch file systems.  The
scratch file systems are intended for temporary uses such as storage
of checkpoints or application input and output. Data and I/O intensive
applications should use the local scratch (or Burst Buffer)
file systems.

These systems should be referenced with the environment variable
`$SCRATCH`.

!!! tip
    On Cori
    the [Burst Buffer](examples/index.md#burst-buffer-test) offers the
    best I/O performance.

!!! warning
    Scratch file systems are not backed up and old files are
    subject to purging.

## File System Licenses

Users can specify the file systems to use for their jobs, using the 
sbatch flag, -L or --licenses. 
A batch job will not start if any of the specified file systems is unavailable
due to maintenance or an outage or if a performance issue with
file system is detected. The following example specifies 
that a job uses both the cscratch1 and community file systems. 

```slurm
#SBATCH -L SCRATCH,cfs
```

Or

```slurm
#SBATCH --licenses=SCRATCH,cfs
```

### Available Licenses on Cori

* `cscratch1` (or `SCRATCH`)
* `cfs`
* `projecta`
* `projectb`
* `dna`
* `seqfs`
* `cvmfs`

## Large Jobs

Large jobs (>1000 MPI tasks) may take longer to start up, especially on
KNL nodes: one solution may be to copy the executable to a local path
on the compute nodes allocated to the job, instead of loading it onto
the compute nodes from a slow file system such as the home.

`srun` provides the option
[`--bcast=/path`](https://slurm.schedmd.com/srun.html#OPT_bcast), which
can be used to copy the desired executable to `/path` and then start
the actual computation.
If one defines a destination path local to the compute node, e.g. in
`/tmp`, this could speed up the job startup time compared to running
executables from a network file system. For example, assuming
`exe_on_slow_fs` is the executable filename, which resides on a slow
file system such as the user home, modify the line of `srun` in your
submit script from this:

```slurm
srun exe_on_slow_fs
```

to this:

```slurm
srun --bcast=/tmp/${USER}_exe_filename exe_on_slow_fs
```

Make sure to choose a temporary path unique to your computation (e.g.
include your username with the variable `$USER`), or you may receive
permission denied errors if trying to overwrite someone else's files.

!!! tip
    There is no real downside to broadcasting the executable with
    slurm, so it can be used with jobs at any scale, especially if you
    experience timeout errors associated with `MPI_Init()`.

## Network Locality

For jobs which are sensitive to interconnect (MPI) performance and
utilize less than ~300 nodes it is possible to request that all nodes
are in a single Aries dragonfly group. The maximum number of nodes in
a switch on Cori is 384, but only some switches are fully populated
with compute nodes as some connections are reserved for other node
types (system, I/O, etc).

Slurm has a concept of "switches" which on Cori are configured to map
to Aries electrical groups. Since this places an additional constraint
on the scheduler a maximum time to wait for the requested topology can
be specified.

!!! example
    Wait up to 60 minutes

    ```slurm
    sbatch --switches=1@60 job.sh
    ```

!!! danger
    When specifying the number of switches take care to request enough
    switches to satisfy the requested number of nodes. If the number
    is too low then an unneccesary delay will be added due to the
    unsatisfiable request.

    A useful heuristic to ensure this is the case is to ensure
    $$
    N_{\mathrm{nodes}} \geq N_{\mathrm{switches}} * 300.
    $$

!!! info "Additional details and information"
	* [Cray XC Series Network (pdf)](https://www.cray.com/sites/default/files/resources/CrayXCNetwork.pdf)

## Core Specialization

Core specialization is a feature designed to isolate system overhead
(system interrupts, etc.) to designated cores on a compute node. It is
generally helpful for running on KNL, especially if the application
does not plan to use all physical cores on a 68-core compute node. Setting
aside 2 or 4 cores for core specialization is recommended.

The `srun` flag for core specialization is `-S` or `--core-spec`.  It
only works in a batch script with `sbatch`.  It can not be requested as
a flag with `salloc` for interactive jobs, since `salloc` is already a
wrapper script for `srun`.

* [Example](examples/index.md#core-specialization)

## Process Placement

Several mechanisms exist to control process placement on NERSC's Cray
systems. Application performance can depend strongly on placement
depending on the communication pattern and other computational
characteristics.

Examples are run on Cori.

### Default

```console
user@nid01041:~> srun -n 8 -c 2 check-mpi.intel.cori|sort -nk 4
Hello from rank 0, on nid01041. (core affinity = 0-63)
Hello from rank 1, on nid01041. (core affinity = 0-63)
Hello from rank 2, on nid01111. (core affinity = 0-63)
Hello from rank 3, on nid01111. (core affinity = 0-63)
Hello from rank 4, on nid01118. (core affinity = 0-63)
Hello from rank 5, on nid01118. (core affinity = 0-63)
Hello from rank 6, on nid01282. (core affinity = 0-63)
Hello from rank 7, on nid01282. (core affinity = 0-63)
```

### `MPICH_RANK_REORDER_METHOD`

The `MPICH_RANK_REORDER_METHOD` environment variable is used to
specify other types of MPI task placement. For example, setting it to
0 results in a round-robin placement:

```console
user@nid01041:~> MPICH_RANK_REORDER_METHOD=0 srun -n 8 -c 2 check-mpi.intel.cori|sort -nk 4
Hello from rank 0, on nid01041. (core affinity = 0-63)
Hello from rank 1, on nid01111. (core affinity = 0-63)
Hello from rank 2, on nid01118. (core affinity = 0-63)
Hello from rank 3, on nid01282. (core affinity = 0-63)
Hello from rank 4, on nid01041. (core affinity = 0-63)
Hello from rank 5, on nid01111. (core affinity = 0-63)
Hello from rank 6, on nid01118. (core affinity = 0-63)
Hello from rank 7, on nid01282. (core affinity = 0-63)
```

There are other modes available with the `MPICH_RANK_REORDER_METHOD`
environment variable, including one which lets the user provide a file
called `MPICH_RANK_ORDER` which contains a list of each task's
placement on each node. These options are described in detail in the
`intro_mpi` man page.

#### `grid_order`

For MPI applications which perform a large amount of nearest-neighbor
communication, e.g., stencil-based applications on structured grids,
Cray provides a tool in the `perftools-base` module called
`grid_order` which can generate a `MPICH_RANK_ORDER` file automatically
by taking as parameters the dimensions of the grid, core count,
etc. For example, to place MPI tasks in row-major order on a Cartesian
grid of size $(4, 4, 4)$, using 32 tasks per node on Cori:

```
cori$ module load perftools-base
cori$ grid_order -R -c 32 -g 4,4,4
# grid_order -R -Z -c 32 -g 4,4,4
# Region 3: 0,0,1 (0..63)
0,1,2,3,16,17,18,19,32,33,34,35,48,49,50,51,4,5,6,7,20,21,22,23,36,37,38,39,52,53,54,55
8,9,10,11,24,25,26,27,40,41,42,43,56,57,58,59,12,13,14,15,28,29,30,31,44,45,46,47,60,61,62,63
```

One can then save this output to a file called `MPICH_RANK_ORDER` and
then set `MPICH_RANK_REORDER_METHOD=3` before running the job, which
tells Cray MPI to read the `MPICH_RANK_ORDER` file to set the MPI task
placement. For more information, please see the man page `man
grid_order` (available when the `perftools-base` module is loaded) on
Cori.

## Hugepages

Huge pages are virtual memory pages which are bigger than the default
page size of 4K bytes. Huge pages can improve memory performance
for common access patterns on large data sets since it helps to reduce
the number of virtual to physical address translations than compated with
using the default 4K. Huge pages also
increase the maximum size of data and text in a program accessible by
the high speed network, and reduce the cost of accessing memory, such as
in the case of many MPI_Alltoall operations. Using hugepages
can help to [reduce the application runtime variability](../performance/variability.md).

To use hugepages for an application (with the 2M hugepages as an example):

```
module load craype-hugepages2M
cc -o mycode.exe mycode.c
```

And also load the same hugepages module at runtime.

The craype-hugepages2M module is loaded by deafult on Cori.
Users could unload the craype-hugepages2M module explicitly to disable the hugepages usage.

!!! note
    The craype-hugepages2M module is loaded by default since the Cori CLE7 upgrade on July 30, 2019.

Due to the hugepages memory fragmentation issue, applications may get
"Cannot allocate memory" warnings or errors when there are not enough
hugepages on the compute node, such as:

```
libhugetlbfs [nid000xx:xxxxx]: WARNING: New heap segment map at 0x10000000 failed: Cannot allocate memory
```

The verbosity level of libhugetlbfs HUGETLB_VERBOSE is set to 0 on
Cori by default to surpress debugging messages.  Users can adjust this
value to obtain more info.

### When to Use Huge Pages

* For MPI applications, map the static data and/or heap onto huge
  pages.
* For an application which uses shared memory, which needs to be
  concurrently registered with the high speed network drivers for
  remote communication.
* For SHMEM applications, map the static data and/or private heap
  onto huge pages.
* For applications written in Unified Parallel C, Coarray Fortran,
  and other languages based on the PGAS programming model, map the
  static data and/or private heap onto huge pages.
* For an application doing heavy I/O.
* To improve memory performance for common access patterns on large
  data sets.

### When to Avoid Huge Pages

* Applications sometimes consist of many steering programs in addition
  to the core application. Applying huge page behavior to all
  processes would not provide any benefit and would consume huge pages
  that would otherwise benefit the core application. The runtime
  environment variable HUGETLB_RESTRICT_EXE can be used to specify the
  susbset of the programs to use hugepages.

* For certain applications if using hugepages either causes issues or
  slowing down performances, users can explicitly unload the
  craype-hugepages2M module.  One such example is that when an
  application forks more subprocesses (such as pthreads) and allocate
  memory, the newly allocated memory are the small 4K pages.

## Task Packing

Users requiring large numbers of single-task jobs have several options at
NERSC. The options include:

* Submitting jobs to the [shared QOS](examples/index.md#shared),
* Using a [workflow tool](workflow-tools.md) to combine the tasks into one
  larger job,
* Using [job arrays](examples/index.md#job-arrays) to submit many individual
  jobs which look very similar.

If you have a large number of independent serial jobs (that is, the jobs do not
have dependencies on each other), you may wish to pack the individual tasks
into one bundled Slurm job to help with queue throughput. Packing multiple
tasks into one Slurm job can be done via multiple `srun` commands in the same
job script
([example](examples/index.md#multiple-parallel-jobs-simultaneously)).
