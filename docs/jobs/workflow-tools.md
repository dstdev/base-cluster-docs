# Workflow Management Tools

Supporting data-centric science involves the movement of data, multi-stage
processing, and visualization at scales where manual control becomes
prohibitive and automation is needed. Workflow technologies can improve the
productivity and efficiency of data-centric science by orchestrating and
automating these steps.

!!! Note "Let us help you find the right tool!"
    Do you have questions about how to choose the right workflow tool for your
    application? Are you unsure about which tools will work on NERSC systems?
    Please open a ticket at [help.nersc.gov](https://help.nersc.gov), explain you would
    like help choosing a workflow tool, and your ticket will be routed to experts
    who can help you.

A NERSC working group review and refresh of this content is currently in
progress; we are actively updating these docs pages with new information as we
evaluate new tools. In the meantime we request the following of users
considering workflow management solutions:

* Before you begin developing a codebase which requires a particular workflow
  manager, please contact NERSC consultants via [help.nersc.gov](https://help.nersc.gov)
  to confirm it can be effectively
  used at NERSC. Some tools have infrastructure needs or operate in a manner
  which is fundamentally incompatible with NERSC systems and we'd like to
  protect users from wasting effort if we can.
* Please do not write your own workflow manager. More than 200 such solutions
  already exist and almost certainly one of them can be found which will
  fit your needs and our infrastructure.
* Please don't do this!!!

```
For i=1=10,000
   srun -n 1 a.out
```

Issuing many `srun`s in a short period of time really stresses our
SLURM scheduler. It will ruin not only your own job performance but
also the performance for all other NERSC users, too. If this is what
you need for your application, please consider a workflow tool. This
is what they were designed to do!

## GNU Parallel

[GNU Parallel](workflow/gnuparallel.md) is a shell tool for executing commands
in parallel and in sequence on a single node. Parallel is a very usable and
effective tool for running High Throughput Computing workloads without data
dependencies at NERSC. Following simple Slurm command patterns allows parallel
to scale up to running tasks in job allocations with multiple nodes.

## TaskFarmer

[TaskFarmer](workflow/taskfarmer.md) is a utility developed at NERSC to
distribute single-node tasks across a set of compute nodes - these can be
single- or multi-core tasks. TaskFarmer tracks which tasks have completed
successfully, and allows straightforward re-submission of failed or un-run jobs
from a checkpoint file.

## Fireworks

[FireWorks](workflow/fireworks.md) is a free, open-source code for defining,
managing, and executing scientific workflows. It can be used to automate
calculations over arbitrary computing resources, including those that have a
queueing system. Some features that distinguish FireWorks are dynamic
workflows, failure-detection routines, and built-in tools and execution modes
for running high-throughput computations at large computing centers. It uses a
centralized server model, where the server manages the workflows and workers
run the jobs.

## Nextflow

[Nextflow](workflow/nextflow.md)

## Papermill

[Papermill](workflow/papermill.md) is a tool that allows users to
run Jupyter notebooks 1) via the command line and 2) in an easily
parameterizable way. Papermill is best suited for Jupyter users who would
like to run the same notebook with different input values.

## Parsl

[Parsl](workflow/parsl.md) is a Python library for programming and executing 
data-oriented workflows in parallel. It lets you express complicated workflows 
with task and data dependencies in a single Python script. Parsl is made with 
HPC in mind, scales well, and runs on many HPC platforms. Under the hood, 
Parsl uses a driver or master process to orchestrate the work. 
Data and tasks are serialized and communicated bidirectional with worker 
process using ZeroMQ sockets. The workers are organized in worker pools and 
launched on the compute infrastructure. 

## Snakemake

[Snakemake](workflow/snakemake.md) is a tool that combines the power of Python
with shell scripting. It allows users to define workflows with complex
dependencies; users can easily visualize the job dependency graph and track
which tasks have been completed and are still pending. Snakemake works best
at NERSC for single node jobs.

## Other Workflow Tools

If you find that these tools don't meet your needs, you can check out some
of the [other](workflow/other_tools.md) workflow tools we currently support.
