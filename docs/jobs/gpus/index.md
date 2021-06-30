# Running Jobs on Perlmutter's GPU nodes

!!! warning
    This page is currently under active development. Check
    back soon for more content.

## Job submit options

### GPU constraint

To submit a job to the GPU nodes you will need to specify a
"constraint" of `gpu` (in the same way you would specify a constraint
of `knl` for KNL nodes on Cori):

```slurm
#SBATCH -C gpu
```

Note that this constraint directive is required; otherwise, job
submission will fail.

### Batch Job QOS

There are several QOSs available to users for submitting batch jobs.
Please see the [queue policy](../policy.md) page for resource limits
associated with each QOS.

For a normal non-interactive batch job, you can submit with the
`regular` queue:

```slurm
#SBATCH -q regular
```

With the `regular` and `interactive` QOSs, each compute node in the
user's job allocation is reserved entirely to the user's job; the
node cannot be accessed by any other job until the existing user's
job reserving that node has ended.

### Number of nodes

You need to specify the number of nodes you wish to use, within the
limit of the QOS of your choice. To request, for example, 2 nodes:

```slurm
#SBATCH -N 2
```

### Number of GPUs

You will also need to specify the number of GPUs you wish to use,
for example to request 8 GPUs:

```slurm
#SBATCH -G 8
```

Note that the argument to `-G` is the *total* number of GPUs allocated
to the job, *not* the number of GPUs *per node* allocated to the
job.

Slurm provides other GPU allocation flags which can ensure a fixed
ratio of GPUs to other allocatable resources, e.g., `--gpus-per-task=<N>`,
`--gpus-per-node=<N>`, etc. The behavior of these flags are described
in the `sbatch` and `salloc` manual pages, or by reading the [SchedMD
documentation](https://slurm.schedmd.com/salloc.html).

### Run Time

You need to specify the requested run time (that is, walltime) for
your job. To request, for example, 1 hour of walltime for your
job:

```slurm
#SBATCH -t 1:00:00
```

The requested run time must be within the time limit set for the
QOS that you choose for the job. Please see the [queue
policy](../policy.md) page for resource limits associated with each
QOS.

### Project

To specify the project account where job are normally charged to:

```slurm
#SBATCH -A <project>
```

Note that jobs are free of charge during Allocation Year 2021.

## Submitting batch jobs

Once you have prepared a batch script containing the appropriate
Slurm directives for your work, you can submit a batch job from a
login node using the `sbatch` command, as explained in the
[Slurm](../index.md) page.

If you can request an [interactive batch job](../index.md#salloc)
using the `salloc` command:

```console
salloc -C gpu -N <# of nodes> -G <# of GPUs> -t <walltime> -q interactive -A <account>
```

## Controlling task and GPU binding

Recall that each GPU node has 4 GPUs and 64 physical cores with 2
hardware threads ("logical cores") per core.

### CPUs

Using the CPUs on the GPU nodes is similar to using Haswell or KNL
compute nodes on Cori. Task binding to CPUs via `-c` and `--cpu-bind`
work the same way on Perlmutter as on the Cori Haswell and KNL
nodes, and is documented in the Affinity webpage's [Slurm
Option](../affinity/index.md#slurm-options).

As a quick reminder, the `--cpu-bind` is to specify which processor
entities MPI tasks are bound to: cores (thus, each task remaining
within a core, not migrating to other ones), hardware threads,
sockets (allowed to migrate within a socket), etc. For performance,
we normally bind tasks to cores (`--cpu-bind=cores`), instead of
allowing them to migrate to different places within a node. The
`-c` (short for `--cpus-per-task`) is to allocate a block of
contiguous "logical cores" to each MPI task. A rule of thumb is to
set it to the number of logical cores divided by the number of tasks
per node.  Since an EPYC 7763 processor has 128 logical cores, and
the `-c` value can be given by floor(64 / (tasks per node)) * 2'.

### GPUs

In a batch job, GPUs can be accessed with or without `srun`:

```slurm
elvis@perlmutter:~> salloc -C gpu -N 1 -G 4 -t 60 -q interactive -A <account>
salloc: Granted job allocation 5305
salloc: Waiting for resource configuration
salloc: Nodes nid001100 are ready for job

elvis@nid001100:~> nvidia-smi
Mon May 24 06:53:00 2021
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.80.02    Driver Version: 450.80.02    CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  A100-SXM4-40GB      On   | 00000000:02:00.0 Off |                    0 |
| N/A   25C    P0    48W / 400W |      0MiB / 40537MiB |      0%   E. Process |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   1  A100-SXM4-40GB      On   | 00000000:41:00.0 Off |                    0 |
| N/A   26C    P0    52W / 400W |      0MiB / 40537MiB |      0%   E. Process |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   2  A100-SXM4-40GB      On   | 00000000:81:00.0 Off |                    0 |
| N/A   27C    P0    50W / 400W |      0MiB / 40537MiB |      0%   E. Process |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+
|   3  A100-SXM4-40GB      On   | 00000000:C1:00.0 Off |                    0 |
| N/A   26C    P0    52W / 400W |      0MiB / 40537MiB |      0%   E. Process |
|                               |                      |             Disabled |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

### GPU Affinity

When allocating CPUs and GPUs to a job in Slurm, the default behavior
is that all GPUs on a particular node allocated to the job can be
accessed by all tasks on that same node:

```console
$ cat gpus_for_tasks.cpp
#include <iostream>
#include <string>
#include <cuda_runtime.h>
#include <mpi.h>

int main(int argc, char **argv) {
  int deviceCount = 0;
  int rank, nprocs;

  MPI_Init (&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &nprocs);

  cudaGetDeviceCount(&deviceCount);

  printf("Rank %d out of %d processes: I see %d GPU(s).\n", rank, nprocs, deviceCount);

  int dev, len = 15;
  char gpu_id[15];
  cudaDeviceProp deviceProp;

  for (dev = 0; dev < deviceCount; ++dev) {
    cudaSetDevice(dev);
    cudaGetDeviceProperties(&deviceProp, dev);
    cudaDeviceGetPCIBusId(gpu_id, len, dev);
    printf("%d for rank %d: "%s"\n", dev, rank, gpu_id);
  }

  MPI_Finalize ();

  return 0;
}

$ CC -o gpus_for_tasks gpus_for_tasks.cpp

$ srun -C gpu -N 1 -n 2 -c 64 --cpu-bind=cores -G 4 ./a.out
Rank 0 out of 2 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:02:00.0
1 for rank 0: 0000:41:00.0
2 for rank 0: 0000:81:00.0
3 for rank 0: 0000:C1:00.0
Rank 1 out of 2 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 1: 0000:02:00.0
1 for rank 1: 0000:41:00.0
2 for rank 1: 0000:81:00.0
3 for rank 1: 0000:C1:00.0
```

Likewise, if 1 GPU is needed for each task in a 2-task job using a
node, the resulting 2 GPUs are visible to both tasks:

```console
$ srun -C gpu -N 1 -n 2 -c 64 --cpu-bind=cores --gpus-per-task=1 ./gpus_for_tasks
Rank 1 out of 2 processes: I see 2 GPUs. Their PCI Bus IDs are:
0 for rank 1: 0000:81:00.0
1 for rank 1: 0000:C1:00.0
Rank 0 out of 2 processes: I see 2 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:81:00.0
1 for rank 0: 0000:C1:00.0
```

For some applications, it is desirable that only certain GPUs can
be accessed by certain tasks. For example, a common programming
model for MPI + GPU applications is such that each GPU on a node
is accessed by only a single task on that node.

Such behavior can be controlled in different ways. One way is to
manipulate the environment variable `CUDA_VISIBLE_DEVICES`, as
documented
[here](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#env-vars).
This approach works on any system with NVIDIA GPUs. The variable
must be configured per process, and may have different values on
different processes, depending on the user's desired GPU affinity
settings.

If the number of tasks is the same as the number of GPUs (4 on the
GPU nodes) on each node and each task is to use one GPU only, a
simple way of initializing `CUDA_VISIBLE_DEVICES` is to set it to
`$SLURM_LOCALID`. The `SLURM_LOCALID` variable is the local ID for
the task within a node. Since the local ID is defined after launching
an `srun` command, you will need to wrap the environment variable
setting as well as the executable run in one shell as in the following
example:

```console
$ cat select_gpu_device            # wrapper script
#!/bin/bash
export CUDA_VISIBLE_DEVICES=$SLURM_LOCALID
exec $*

$ srun -C gpu -N 1 -n 2 -c 64 --cpu-bind=cores --gpus-per-task=1 ./select_local_device ./gpus_for_tasks
Rank 1 out of 2 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 1: 0000:C1:00.0
Rank 0 out of 2 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:81:00.0
```

Another way to achieve a similar result is to use Slurm's GPU
affinity flags.  In particular, the `--gpu-bind` flag may be supplied
to either `salloc`, `sbatch`, or `srun` in order to control which
tasks can access which GPUs. A description of the `--gpu-bind` flag
is documented [here](https://slurm.schedmd.com/srun.html) and via
`man srun`. The
`--gpu-bind=map_gpu:<gpu_id_for_task_0>,<gpu_id_for_task_1>,...`
option sets the order of GPUs to be assigned to MPI tasks. For
example, adding `--gpu-bind=map_gpu:0,1` results in assigning GPUs
0 and 1 to MPI tasks in a round-robin fashion:

```console
$ srun -C gpu -N 1 -n 2 -c 64 --cpu-bind=cores --gpus-per-task=1 --gpu-bind=map_gpu:0,1 ./gpus_for_tasks
Rank 0 out of 2 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:81:00.0
Rank 1 out of 2 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 1: 0000:C1:00.0
```

such that each task on the node may access a single, unique GPU.

If a MPI task needs to access only one GPU, there is a convienient
option for `--gpu-bind` flag. With `--gpu-bind=single:<tasks_per_gpu>`,
the first `<tasks_per_gpu>` MPI tasks are bound to the first GPU
available, the second `<tasks_per_gpu>` tasks are bound to the
second GPU available, etc. The following is a hypothetical example
for 6 MPI tasks on a node, sharing 4 GPUs:

```console
$ srun -C gpu -N 1 -n 6 -c 20 --cpu-bind=cores --gpus-per-node=4 --gpu-bind=single:2,2,1,1 ./gpus_for_tasks
Rank 4 out of 6 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 4: 0000:81:00.0
Rank 1 out of 6 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 1: 0000:02:00.0
Rank 3 out of 6 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 3: 0000:41:00.0
Rank 2 out of 6 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 2: 0000:41:00.0
Rank 5 out of 6 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 5: 0000:81:00.0
Rank 0 out of 6 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:02:00.0
```

To run a job across 8 GPU nodes using 32 tasks total, with each
task bound to one GPU, one could run the following:

```console
$ srun -C gpu -N 8 -n 32 -c 32 --cpu-bind=cores --gpus-per-task=1 --gpu-bind=map_gpu:0,1,2,3 ./gpus_for_tasks
Rank 31 out of 32 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 31: 0000:C1:00.0
Rank 7 out of 32 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 7: 0000:C1:00.0
Rank 3 out of 32 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 3: 0000:C1:00.0
...
Rank 20 out of 32 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 20: 0000:02:00.0
Rank 24 out of 32 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 24: 0000:02:00.0
Rank 8 out of 32 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 8: 0000:02:00.0
```

### More GPU affinity examples

!!! Note "`--gpus-per-task` does not enforce GPU affinity or binding"
    Despite what its name suggests, `--gpus-per-task` in the examples
    below only *counts* the number of GPUs to allocate to the job;
    it does not enforce any binding or affinity of GPUs to CPUs or
    tasks.

#### 1 node, 1 task, 1 GPU

```slurm
#!/bin/bash
#SBATCH -A <account>
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -t 1:00:00
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH -c 128
#SBATCH --gpus-per-task=1

export SLURM_CPU_BIND="cores"
srun ./gpus_for_tasks
```

Output:

```console
Rank 0 out of 1 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:C1:00.0
```

#### 1 node, 4 tasks, 4 GPUs, all GPUs visible to all tasks

```slurm
#!/bin/bash
#SBATCH -A <account>
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -t 1:00:00
#SBATCH -n 4
#SBATCH --ntasks-per-node=4
#SBATCH -c 32
#SBATCH --gpus-per-task=1

export SLURM_CPU_BIND="cores"
srun ./gpus_for_tasks
```

Output:

```slurm
Rank 0 out of 4 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:02:00.0
1 for rank 0: 0000:41:00.0
2 for rank 0: 0000:81:00.0
3 for rank 0: 0000:C1:00.0
Rank 2 out of 4 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 2: 0000:02:00.0
1 for rank 2: 0000:41:00.0
2 for rank 2: 0000:81:00.0
3 for rank 2: 0000:C1:00.0
Rank 3 out of 4 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 3: 0000:02:00.0
1 for rank 3: 0000:41:00.0
2 for rank 3: 0000:81:00.0
3 for rank 3: 0000:C1:00.0
Rank 1 out of 4 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 1: 0000:02:00.0
1 for rank 1: 0000:41:00.0
2 for rank 1: 0000:81:00.0
3 for rank 1: 0000:C1:00.0
```

#### 1 node, 4 tasks, 4 GPUs, 1 GPU visible to each task

```slurm
#!/bin/bash
#SBATCH -A <account>
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -t 1:00:00
#SBATCH -n 4
#SBATCH --ntasks-per-node=4
#SBATCH -c 32
#SBATCH --gpus-per-task=1
#SBATCH --gpu-bind=map_gpu:0,1,2,3

export SLURM_CPU_BIND="cores"
srun ./gpus_for_tasks
```

Output:

```slurm
Rank 0 out of 4 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:02:00.0
Rank 3 out of 4 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 3: 0000:C1:00.0
Rank 2 out of 4 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 2: 0000:81:00.0
Rank 1 out of 4 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 1: 0000:41:00.0
```

#### 4 nodes, 16 tasks, 16 GPUs, all GPUs visible to all tasks

```slurm
#!/bin/bash
#SBATCH -A <account>
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -t 1:00:00
#SBATCH -n 16
#SBATCH --ntasks-per-node=4
#SBATCH -c 32
#SBATCH --gpus-per-task=1

export SLURM_CPU_BIND="cores"
srun ./gpus_for_tasks
```

Output:

```slurm
Rank 13 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 13: 0000:02:00.0
1 for rank 13: 0000:41:00.0
2 for rank 13: 0000:81:00.0
3 for rank 13: 0000:C1:00.0
Rank 3 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 3: 0000:02:00.0
1 for rank 3: 0000:41:00.0
2 for rank 3: 0000:81:00.0
3 for rank 3: 0000:C1:00.0
Rank 11 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 11: 0000:02:00.0
1 for rank 11: 0000:41:00.0
2 for rank 11: 0000:81:00.0
3 for rank 11: 0000:C1:00.0
Rank 5 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 5: 0000:02:00.0
1 for rank 5: 0000:41:00.0
2 for rank 5: 0000:81:00.0
3 for rank 5: 0000:C1:00.0
Rank 15 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 15: 0000:02:00.0
1 for rank 15: 0000:41:00.0
2 for rank 15: 0000:81:00.0
3 for rank 15: 0000:C1:00.0
Rank 14 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 14: 0000:02:00.0
1 for rank 14: 0000:41:00.0
2 for rank 14: 0000:81:00.0
3 for rank 14: 0000:C1:00.0
Rank 12 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 12: 0000:02:00.0
1 for rank 12: 0000:41:00.0
2 for rank 12: 0000:81:00.0
3 for rank 12: 0000:C1:00.0
Rank 9 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 9: 0000:02:00.0
1 for rank 9: 0000:41:00.0
2 for rank 9: 0000:81:00.0
3 for rank 9: 0000:C1:00.0
Rank 10 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 10: 0000:02:00.0
1 for rank 10: 0000:41:00.0
2 for rank 10: 0000:81:00.0
3 for rank 10: 0000:C1:00.0
Rank 8 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 8: 0000:02:00.0
1 for rank 8: 0000:41:00.0
2 for rank 8: 0000:81:00.0
3 for rank 8: 0000:C1:00.0
Rank 1 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 1: 0000:02:00.0
1 for rank 1: 0000:41:00.0
2 for rank 1: 0000:81:00.0
3 for rank 1: 0000:C1:00.0
Rank 2 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 2: 0000:02:00.0
1 for rank 2: 0000:41:00.0
2 for rank 2: 0000:81:00.0
3 for rank 2: 0000:C1:00.0
Rank 0 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:02:00.0
1 for rank 0: 0000:41:00.0
2 for rank 0: 0000:81:00.0
3 for rank 0: 0000:C1:00.0
Rank 6 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 6: 0000:02:00.0
1 for rank 6: 0000:41:00.0
2 for rank 6: 0000:81:00.0
3 for rank 6: 0000:C1:00.0
Rank 7 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 7: 0000:02:00.0
1 for rank 7: 0000:41:00.0
2 for rank 7: 0000:81:00.0
3 for rank 7: 0000:C1:00.0
Rank 4 out of 16 processes: I see 4 GPUs. Their PCI Bus IDs are:
0 for rank 4: 0000:02:00.0
1 for rank 4: 0000:41:00.0
2 for rank 4: 0000:81:00.0
3 for rank 4: 0000:C1:00.0
```

#### 4 nodes, 16 tasks, 16 GPUs, 1 GPU visible to each task

```slurm
#!/bin/bash
#SBATCH -A <account>
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -t 1:00:00
#SBATCH -n 16
#SBATCH --ntasks-per-node=4
#SBATCH -c 32
#SBATCH --gpus-per-task=1
#SBATCH --gpu-bind=map_gpu:0,1,2,3

export SLURM_CPU_BIND="cores"
srun ./gpus_for_tasks
```

Output:

```slurm
Rank 6 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 6: 0000:81:00.0
Rank 13 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 13: 0000:41:00.0
Rank 1 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 1: 0000:41:00.0
Rank 10 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 10: 0000:81:00.0
Rank 15 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 15: 0000:C1:00.0
Rank 9 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 9: 0000:41:00.0
Rank 7 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 7: 0000:C1:00.0
Rank 14 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 14: 0000:81:00.0
Rank 11 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 11: 0000:C1:00.0
Rank 5 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 5: 0000:41:00.0
Rank 12 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 12: 0000:02:00.0
Rank 8 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 8: 0000:02:00.0
Rank 4 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 4: 0000:02:00.0
Rank 2 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 2: 0000:81:00.0
Rank 3 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 3: 0000:C1:00.0
Rank 0 out of 16 processes: I see 1 GPUs. Their PCI Bus IDs are:
0 for rank 0: 0000:02:00.0
```

## CUDA-Aware MPI

HPE Cray MPI is a CUDA-aware MPI implementation. This means that
the programmer can use pointers to GPU device memory in MPI buffers,
and the MPI implementation will correctly copy the data in GPU
device memory to/from the network interface card's (NIC's) memory,
either by implicitly copying the data first to host memory and then
copying the data from host memory to the NIC; or, in hardware which
supports [GPUDirect
RDMA](https://on-demand.gputechconf.com/gtc/2016/presentation/s6264-davide-rossetti-GPUDirect.pdf),
the data will be copied directly from the GPU to the NIC, bypassing
host memory altogether.

An example of this is shown below:

```C
#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>
#include <cuda_runtime.h>

int main(int argc, char *argv[]) {
    int myrank;
    float *val_device, *val_host;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

    val_host = (float*)malloc(sizeof(float));
    cudaMalloc((void **)&val_device, sizeof(float));

    *val_host = -1.0;
    if (myrank != 0) {
      printf("%s %d %s %f\n", "I am rank", myrank, "and my initial value is:", *val_host);
    }

    if (myrank == 0) {
        *val_host = 42.0;
        cudaMemcpy(val_device, val_host, sizeof(float), cudaMemcpyHostToDevice);
        printf("%s %d %s %f\n", "I am rank", myrank, "and will broadcast value:", *val_host);
    }

    MPI_Bcast(val_device, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);

    if (myrank != 0) {
      cudaMemcpy(val_host, val_device, sizeof(float), cudaMemcpyDeviceToHost);
      printf("%s %d %s %f\n", "I am rank", myrank, "and received broadcasted value:", *val_host);
    }

    cudaFree(val_device);
    free(val_host);

    MPI_Finalize();
    return 0;
}
```

The above C code can be compiled with HPE Cray MPI using:

```slurm
$ cc -o cuda-aware-bcast.ex cuda-aware-bcast.c

$ export MPICH_GPU_SUPPORT_ENABLED=1

$ srun -C gpu -n 4 -G 4 --exclusive ./cuda-aware-bcast.ex
I am rank 1 and my initial value is: -1.000000
I am rank 1 and received broadcasted value: 42.000000
I am rank 0 and will broadcast value: 42.000000
I am rank 2 and my initial value is: -1.000000
I am rank 2 and received broadcasted value: 42.000000
I am rank 3 and my initial value is: -1.000000
I am rank 3 and received broadcasted value: 42.000000
```

The `MPICH_GPU_SUPPORT_ENABLED` environment variable must be enabled
if the application is CUDA-aware. Please read the `intro_mpi` man
page.

## Running Single-GPU Tasks in Parallel

Users who have many independent single-GPU tasks may wish to pack these into
one job which runs the tasks in parallel on different GPUs. There are multiple
ways to accomplish this; here we present one example.

### `srun`

The Slurm `srun` command can be used to launch individual tasks, each allocated
some amount of resources requested by the job script. An example of this is:

```slurm
#!/bin/bash
#SBATCH -A <account>
#SBATCH -C gpu
#SBATCH -G 2
#SBATCH -N 1
#SBATCH -t 5

srun --gres=craynetwork:0 -n 1 -G 1 ./a.out &
srun --gres=craynetwork:0 -n 1 -G 1 ./b.out &
wait
```

Each `srun` invocation requests one task and one GPU, and requesting
zero `craynetwork` resources per task is required to allow the tasks
to run in parallel. The `&` at the end of each line puts the tasks
in the background, and the final `wait` command is needed to allow
all of the tasks to run to completion.

!!! danger "Do not use `srun` for large numbers of tasks"
    This approach is feasible for relatively small numbers (i.e.,
    tens) of tasks but **should not** be used for hundreds or
    thousands of tasks. To run larger numbers of tasks, GNU `parallel`
    is preferred, which will be provided on Perlmutter soon.

[comment]: <> (### GNU parallel)

