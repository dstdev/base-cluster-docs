# Queue Policies

!!! warning
    This page is currently under active development. Check
    back soon for more content.

This page details the QOS and queue usage policies.
[Examples](examples/index.md) for each type of Cori job are available.

Jobs are submitted to different queues depending on the queue
constraints and the user's desired outcomes. Most jobs are submitted
to the "regular" queue, but a user with a particularly urgent
scientific emergency may decide to submit to the premium queue for
faster turnaround. Another user who does not need the results of this
run for many weeks may elect to use the low queue to cut down on
costs. And a user who needs fast turnaround while they are using the
large telescope could prearrange with NERSC to use the realtime queue
for these runs.

These different purposes are served by what is known as "Quality of
Service" (QOS): each queue has a different service level in terms of
priority, run and submit limits, walltime limits, node-count limits,
and cost. The QOS factor is a multiplier that is used in the
computation of charges. In exchange for better turnaround time, a user
is charged extra to use premium; in exchange for their flexibility in
runtime, a user of the flex queue is rewarded with a substantial
discount.

## QOS Limits and Charges

### Perlmutter

| QOS                           | Max nodes    | Max time (hrs) | Submit limit | Run limit | Priority | QOS Factor | Charge per Node-Hour |
|-------------------------------|--------------|----------------|--------------|-----------|----------|------------|----------------------|
| [regular](#p-regular)         | 128          | 24             | -            | -         | -        | -          | 0                    |
| [interactive](#p-interactive) | 4            | 4              | -            | -         | -        | -          | 0                    |

### Cori Haswell

| QOS                         | Max nodes        | Max time (hrs) | Submit limit | Run limit | Priority | QOS Factor       | Charge per Node-Hour |
|-----------------------------|------------------|----------------|--------------|-----------|----------|------------------|----------------------|
| [regular](#regular)         | 1932[^hsw-reg]   | 48             | 5000         | -         | 4        | 1                | 140                  |
| shared[^shared]             | 0.5              | 48             | 10000        | -         | 4        | 1                | 140[^shared]         |
| [interactive](#interactive) | 64[^interactive] | 4              | 2            | 2         | -        | 1                | 140                  |
| [debug](#debug)             | 64               | 0.5            | 5            | 2         | 3        | 1                | 140                  |
| [premium](#premium)         | 1772             | 48             | 5            | -         | 2        | 2 -> 4[^premium] | 280[^premium]        |
| [flex](#flex)               | 64               | 48             | 5000         | -         | 6        | 0.5              | 70                   |
| [overrun](#overrun)         | 1772             | 48             | 5000         | -         | 5        | 0                | 0                    |
| xfer                        | 1 (login)        | 48             | 100          | 15        | -        | -                | 0                    |
| bigmem                      | 1 (login)        | 72             | 100          | 1         | -        | 1                | 140                  |
| [realtime](#realtime)       | custom           | custom         | custom       | custom    | 1        | custom           | custom               |
| [compile](#compile)         | 1 (login)        | 24             | 5000         | 2         | -        | -                | 0                    |

### Cori KNL

| QOS                         | Max nodes        | Max time (hrs) | Submit limit | Run limit | Priority | QOS Factor       | Charge per Node-Hour |
|-----------------------------|------------------|----------------|--------------|-----------|----------|------------------|----------------------|
| [regular](#regular)         | 9489             | 48             | 5000         | -         | 4        | 1                | 80                   |
| [interactive](#interactive) | 64[^interactive] | 4              | 2            | 2         | -        | 1                | 80                   |
| [debug](#debug)             | 512              | 0.5            | 5            | 2         | 3        | 1                | 80                   |
| [premium](#premium)         | 9489             | 48             | 5            | -         | 2        | 2 -> 4[^premium] | 160[^premium]        |
| [low](#low)                 | 9489             | 48             | 5000         | -         | 5        | 0.5              | 40                   |
| [flex](#flex)               | 256              | 48             | 5000         | -         | 6        | 0.25             | 20                   |
| [overrun](#overrun)         | 9489             | 48             | 5000         | -         | 7        | 0                | 0                    |

[^hsw-reg]:
Batch jobs submitted to the Haswell partition requesting more than 512 nodes
must go through a
[compute reservation](https://nersc.servicenowservices.com/sp/?id=sc_cat_item&sys_id=1c2ac48f6f8cd2008ca9d15eae3ee4a5&sysparm_category=e15706fc0a0a0aa7007fc21e1ab70c2f).

[^shared]:
Shared jobs are only charged for the fraction of the node resources used.

[^interactive]:
Batch job submission is **not** enabled and the 64-node limit applies
**per project** not per user.

[^premium]:
The charge factor for "premium" QOS will be
doubled once a project has spent more than 20 percent of its
allocation in "premium".

### JGI Accounts

There are 192 Haswell nodes reserved for the "genepool" and
"genepool_shared" QOSes combined.  Jobs run with the "genepool" QOS
uses these nodes exclusively. Jobs run with the "genepool_shared" QOS
can share nodes.

| QOS             | Max nodes | Max time (hrs) | Submit limit | Run limit | Priority |
|-----------------|-----------|----------------|--------------|-----------|----------|
| genepool        | 16        | 72             | 500          | -         | 3        | 
| genepool_shared | 0.5       | 72             | 500          | -         | 3        | 

## Available QOSs

There are many different QOSs at NERSC, each with a different purpose.

### Perlmutter

#### Regular <a name="p-regular"></a>

The standard queue for most production workloads.

#### Interactive <a name="p-interactive"></a>

The QOS is to be used for code development, testing, debugging,
analysis and other workflows in an interactive session. Jobs should
be submitted via `salloc -q interactive` along with other `salloc`
flags.

A pool of 50 nodes are reserved during business hours for interactive
use, which will be released overnight for large-scale jobs.

### Cori

#### Regular

The standard queue for most production workloads.

#### Debug

The "debug" QOS is to be used for code development, testing, and
debugging. Production runs are not permitted in the debug QOS. User
accounts are subject to suspension if they are determined to be using
the debug QOS for production computing. In particular, **job
"chaining" in the debug QOS is not allowed**. Chaining is defined as
using a batch script to submit another batch script.

#### Interactive

The [interactive](./interactive.md) QOS is to be used for code
development, testing, debugging, analysis and other workflows in an
interactive session.  Jobs should be submitted via `salloc -q
interactive` along with other `salloc` flags (such as number of nodes,
node feature, and walltime request, etc.).

!!! note
    Batch job submission is not enabled and the 64-node limit
    applies **per project** not per user.

#### Premium

The intent of the premium QOS is to allow for faster turnaround for
unexpected scientific emergencies where results are needed right
away. NERSC has a target of keeping premium usage at or below 10
percent of all usage. Premium should be used infrequently and with
care.

!!! Warning
    The charge factor for premium will
    increase once a project has used 20 percent of its allocation on
    premium. PIs will be able to control which of their users can use
    premium for their allocation. For instruction on adding users to
    premium queue please see
    [Enabling the premium QOS](../../iris/iris-for-pis/#enabling-the-premium-qos-available-from-ay21).

!!! Note
    Premium jobs are not eligible for discounts.

#### Low

The intent of the "low" QOS is to allow non-urgent jobs to run with
lower priority and a lower usage charge.

#### Flex

The intent of the “flex" QOS is to encourage user jobs that can
produce useful work with a relatively short flexible amount run
time. You can access the flex queue by submitting with `-q flex`

The flexible time allocation allows better throughput for jobs as they
may fit into the gaps of the job schedule.

!!! tip "Discount"
    This QOS has a low charge factor.

!!! example
    Jobs that are capable of
    [checkpoint/restart](../development/checkpoint-restart/index.md)
    are ideal candidates for the flex QOS.

You **must** specify a minimum running time for this job of 2 hours or
less with the `--time-min` flag. Jobs submitted without the
`--time-min` flag will be automatically rejected by the batch
system. The maximum wall time request limit (requested via `--time` or
`-t` flag) for flex jobs must be greater than 2 hours and cannot
exceed 48 hours.

!!! example
    A flex job requesting a minimum time of 1.5 hours, and max wall
    time of 10 hrs:
    ```
    sbatch -q flex --time-min=01:30:00 --time=10:00:00 my_batch_script.sl
    ```

#### Overrun

The intent of the overrun QOS is to allow users with a zero or
negative balance in one of their projects to continue to run jobs. The
charging rate for this QOS is 0 and it has the lowest priority on all
systems.

!!! note
    The overrun QOS is not available for jobs submitted against a
    project with a positive balance.

If you meet the above criteria, you can access the overrun queue by
submitting with `-q overrun` (`-q shared_overrun` for the shared
queue). In addition, you **must** specify a minimum running time for this
job of 4 hours or less with the `--time-min` flag. Jobs submitted
without these flags will be automatically rejected by the batch system.

!!! tip
    We recommend you implement
    [checkpoint/restart](../development/checkpoint-restart/index.md)
    your overrun jobs to save your progress.

!!! example
    A job requesting a minimum time of 1.5 hours:

    ```
    sbatch -q overrun --time-min=01:30:00 my_batch_script.sl
    ```

#### Realtime

The "realtime" QOS is only available via [special request](https://nersc.servicenowservices.com/catalog_home.do?sysparm_view=catalog_default).
It is intended for jobs that are connected with an external realtime
component that _requires_ on-demand processing.

#### Compile

The `compile` QOS is intended for workflows that regularly compile codes from
source such as the compiling stage in DevOps models that leverage continuous
integration. Jobs are run on one Cori Haswell node and there is no charge for
using the `compile` QOS.

## Charging

Jobs charges are a function of the number of nodes and the amount of
time used by the job, as well as the job's QOS factor and the machine
charge factor. For more information on how jobs are charged please see
the [Computer Usage
Charging](../../policies/charging-policy/#computer-usage-charging)
section of the NERSC usage charging policy.

!!! warning
	For users who are members of multiple NERSC projects,
	charges are made to the default project, as set
	in [Iris](https://iris.nersc.gov), unless the `#SBATCH
	--account=<NERSC project>` flag has been set.

!!! note
    Jobs are charged only for the actual walltime used. That is, if a
    job uses less time than requested, the corresponding project is
    charged only for the actual job duration.

During Allocation Year 2021 jobs run on Perlmutter will be free of
charge.

### Discounts

 * **big job discount** The "regular" QOS charges on Cori KNL are
   discounted by 50% if a job uses 1024 or more nodes. This discount
   is only available in the regular qos for Cori KNL.

In addition several qos's offer reduced charging rates:

 * The "low" QOS (available on Cori KNL only) is charged 50% as
   compared to the "regular" QOS, but no extra large job discount
   applies.

 * The "flex" QOS is charged 50% as compared to the "regular" QOS on Haswell 
   and 25% as compared to the "regular" qos on KNL.

 * The "overrun" QOS is free of charge and is only available to projects
   that are out of allocation time. Please refer to the
   [overrun](#overrun) section for more details.

## Held jobs

User held jobs that were submitted more than 12 weeks ago will be
deleted.
