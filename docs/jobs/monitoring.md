# Monitoring Jobs

!!!note
    Continuously running squeue/sqs using watch, and especially
    multiple instances of "watch squeue/sqs" is not allowed. When many
    users are doing this at once it adversely impacts the performance
    of the job scheduler, which is a shared resource.
    
    If you must monitor your workload, run only single instances of
    `squeue` or `sqs`. If `watch` is *essential* to your workflow then
    limit the refresh interval to 1 min (`watch -n 60`) and be sure to
    terminate the process when you are not actively using it.

Additionally the `sacct` command (`sacct -X -s pd,r`) uses less
expensive queries for much of the same information, but the same
advice about `watch` applies.

For users who are interested in monitoring their job's resource usage while the
job is running, the section on how to log into compute nodes while jobs are
running [below](#how-to-log-into-compute-nodes-running-your-jobs).

## sqs

`sqs` is a NERSC custom wrapper for the Slurm native `squeue` script with a chosen default format 
to view job information in the batch queue managed by Slurm.  The `sqs` command without any 
flag displays queued jobs for the logged-in user.  Invoking `sqs -a` displays the jobs of all users. 

`sqs` is fully compatible with `squeue` in that it takes any flag that is accepted by `squeue`,
thus enabling more flexibility in customizing the output. For
example, you could choose to only see running jobs with `-t R`, or you
could overwrite the default format of `sqs` with the `-o` flag to provide the 
list and format for fields of your own interest. 

!!! note
    Please refer to `sqs --help` and the `squeue` man page for the available flags and more information.

```
$ sqs
JOBID            ST USER      NAME          NODES TIME_LIMIT       TIME  SUBMIT_TIME          QOS             START_TIME           FEATURES       NODELIST(REASON
32308177         R  elvis     myjob1        1024  1-00:00:00       0:00  2020-06-08T05:05:12  regular_0       2020-06-10T06:00:00  knl&quad&cache nid0[2435-2443,
32308268         PD elvis     myjob2        1024  1-00:00:00       0:00  2020-06-08T05:19:59  regular_0       2020-06-10T06:00:00  knl&quad&cache (ReqNodeNotAvai         knl&quad&cache (Priority)     
32305323         PD elvis     myjob3          48     6:00:00       0:00  2020-06-07T05:08:36  regular_1       N/A                  knl&quad&cache (Nodes required
32305332         PD elvis     myjob4          48     6:00:00       0:00  2020-06-07T05:09:06  regular_1       N/A                  knl&quad&cache (Nodes required
```

## squeue 

`squeue` provides information about jobs in Slurm scheduling queue, and is best
used for viewing jobs and job step information for active jobs (PENDING, RUNNING, SUSPENDED).
For more details on squeue refer to the [squeue manual](https://slurm.schedmd.com/squeue.html)
or run ``squeue --help``, ``man squeue``.

To view current user jobs:

```
squeue -u $USER
```

The same output can be retrieved via ``--me`` option which is equivalent to ``--user=<$USER>``

```
squeue --me
```

To view all running jobs for the current user: 

```
squeue --me -t RUNNING
``` 

To view all pending jobs for current user:

```
squeue --me -t PENDING
```

To view all pending jobs in QOS `shared`:

```
squeue -q shared -t PENDING
```

To view all running jobs for current user on `shared` qos: 

```console
$ squeue --me -q shared -t RUNNING  
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
             1000    shared netcdf_r   user1  R    1:16:47      1 nid00527
```

To view all jobs for a particular account (project), use `-A <nersc_project>`:

```console
$ squeue -A <nersc_project>
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          2000 debug_knl tokio-ab    admin1 PD       0:00    256 (Burst buffer pre_run error)
          2001 regular_h mpi4py-i   admin2 PD       0:00    150 (Priority)
          2002 regular_h mpi4py-i   admin3 PD       0:00    150 (Priority)
          2003 regular_h preproce    admin4 PD       0:00      1 (Priority)          
```

To view filter jobs, use the `-j` option followed by the job ID. You can specify
multiple job IDs separated by commas.

```console
$ squeue -j 2542,2560
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          2542    shared wrfpostp user1 PD       0:00      1 (Dependency)
          2560    shared netcdf_r  user2 PD       0:00      1 (Resources)
```

To view a job step use the `--steps` option with the job step ID. 

```console
$ squeue --steps 1001.0            
         STEPID     NAME PARTITION     USER      TIME NODELIST
     1001.0 vasp_std regular_k elvis   5:19:26 nid0[2520-2527]
```

## sacct

`sacct` is used to report job or job step accounting information about
active or completed jobs. You can directly invoke `sacct` without any arguments 
and it will show jobs for the current user. sacct can be used for monitoring but
it is primarily used for [Job Accounting](#job-accounting).

For a complete list of `sacct` options please refer to the
[sacct manual](https://slurm.schedmd.com/sacct.html) or run `man sacct`.

## jobstats

`jobstats` provides slurm accounting and job details from `sacct`, `sreport` and 
`squeue`. You can run `jobstats` without any arguments and it will show a report
for the current user from `sreport` for today. If you have any pending or running
jobs it will show that as well.

```console
$ jobstats
User: XXXXXX 
Default Account: YYYYY
User is part of the following slurm accounts ['YYYYY']
User Raw Share: 1
User Raw Usage: 0
Number of Pending Jobs: 0
Number of Running Jobs: 0
Total Jobs Completed: 0
Total Jobs Completed Successfully: 0
Total Jobs Failed: 0
Total Jobs Cancelled: 0
Total Jobs Timeout: 0

Today: 06/15/2020 12:13:37 sreport
--------------------------------------------------------------------------------
Top 10 Users 2020-06-14T00:00:00 - 2020-06-14T23:59:59 (86400 secs)
Usage reported in CPU Hours
--------------------------------------------------------------------------------
  Cluster     Login     Proper Name         Account         Used        Energy 
--------- --------- --------------- --------------- ------------ ------------- 
```

Shown below is a list of options for the `jobstats` command.

```shell
$ jobstats --help
usage: jobstats [-h] [-u USER] [-S START] [-E END] [-j]
                [--state {COMPLETED,FAILED,TIMEOUT,CANCELLED}] [-a]

slurm utility for display user job statistics, reporting, and account detail.

optional arguments:
  -h, --help            show this help message and exit
  -u USER, --user USER  Select a user
  -S START, --start START
                        Start Date Format: YYYY-MM-DD
  -E END, --end END     End Date Format: YYYY-MM-DD
  -j, --jobsummary      Display job summary for user
  --state {COMPLETED,FAILED,TIMEOUT,CANCELLED}
                        Filter by Job State
  -a, --account         Display information on account shares that user
                        belongs to

Developed by Shahzeb Siddiqui <shahzebmsiddiqui@gmail.com>
```

For more information see [jobstats documentation](https://github.com/shahzebsiddiqui/jobstats).

## sstat

`sstat` is used to display various status information of a running job or job
step. For example, one may wish to see the maximum memory usage (resident set
size) of all tasks in a running job.

```
$ sstat -j 864934 -o JobID,MaxRSS
       JobID     MaxRSS 
------------ ---------- 
864934.0          4333K 
```

For a complete list of `sstat` options and examples please see
[sstat manual](https://slurm.schedmd.com/sstat.html).

## Email notification

You can add directives within your job script to notify you when
your job starts, finishes, or fails. Using the `--mail-type` 
option, you can select one of `begin`, `end`, or `fail` 
(respectively), or two or more in a comma-separated list (as 
below). You should specify the email address to which the 
notifications should go with the `--mail-user` option.

```
#SBATCH --mail-type=begin,end,fail
#SBATCH --mail-user=user@domain.com
```

## How to log into compute nodes running your jobs

It can be useful for troubleshooting or diagnostics to log into compute nodes
running one's job in order to observe activity on those nodes. Below is the
series of steps required to log into a compute node while one's job is running.

!!! Note "Access to compute nodes is enabled only while the job is running"
    A user's SSH access to compute nodes is enabled only during the lifetime of
    the job.  When the job ends, the user's SSH connections to all compute
    nodes in the job will be disconnected.

1. Retrieve the list of nodes that your job is running on. This will either
print the host name `nid*****` or a range of host names -- if the job has more
than one node -- in square brackets.

    ```
    scontrol show job <jobid> | grep -oP  'NodeList=nid(\[.+\]|.+)'
    ```

2. SSH into a mom node:

    ```
    ssh cmom01              # On Cori
    ```

3. From the mom node, you can ssh into any `nid*****` node in the `scontrol`
list generated in step 1.

!!! Note "Requesting the head-node ID"
    If you need the head-node only (eg. for DMTCP application) use `BatchHost`
    instead of `NodeList`:

    ```
    scontrol show job <jobid>|grep -oP 'BatchHost=\K\w+'
    ```

## Updating Jobs

### Cancel jobs

To cancel a specific job:

```
scancel $JobID
```

You can also cancel more than one job in a single call to `scancel`:

```
scancel $JobID1 $JobID2
```

To cancel all jobs owned by a user

!!!warning
    If you want to cancel several hundred jobs, do not perform this action in bulk change; cancel jobs by subset instead.
   
```
scancel -u $USER
```

Because `scancel` sends a remote procedure call to the Slurm daemon, a
degradation of service can result from many `scancel` calls happening
all at once. Therefore we recommend using as few individual calls to
this function as possible. In particular, do not wrap `scancel` in a
loop in a script or other function.

### Change timelimit

```
scontrol update jobid=$JobID timelimit=$new_timelimit
```

### Change QOS

```
scontrol update jobid=$JobID qos=$new_qos
```

### Change account

```
scontrol update jobid=$JobID account=$new_project_to_charge
```

!!! note
	The new repo must be eligible to run the job.

## Controlling Jobs

Prevent a pending job from being started:

```
scontrol hold $JobID
```

!!! note
    A held job will lose its accumulated wait time in the queue. Later if this job is released, 
    it will have the same priority as a newly submitted job.

Release a previously held job (``scontrol hold```):

```
scontrol release $JobID
```

To requeue (cancel and rerun) a particular job:

```
scontrol requeue $JobID
``` 

## Job Accounting

??? example "sacct example"
    ```
    $ sacct      
           JobID    JobName  Partition    Account  AllocCPUS      State ExitCode 
    ------------ ---------- ---------- ---------- ---------- ---------- -------- 
    31170188             sh interacti+     nstaff        272     FAILED      1:0 
    31170188.ex+     extern                nstaff        272  COMPLETED      0:0 
    31170188.0         bash                nstaff          1     FAILED      1:0 
    31170188.1        a.out                nstaff        272  COMPLETED      0:0 
    31171781             sh       resv     nstaff        272  COMPLETED      0:0 
    31171781.ex+     extern                nstaff        272  COMPLETED      0:0 
    31171781.0         bash                nstaff          1  COMPLETED      0:0 
    31172253             sh       resv     nstaff        272    TIMEOUT      0:0 
    31172253.ex+     extern                nstaff        272  COMPLETED      0:0 
    31172253.0         bash                nstaff          1  COMPLETED      0:0 
    ```

You can format columns as you wish using the `--format` option. For example, 
we can format columns based on **User** **JobName** **State** and **Submit** as follows

??? example "sacct format example"
    ```
    $ sacct --format=User,JobName,State,Submit
         User    JobName      State              Submit 
    --------- ---------- ---------- ------------------- 
     user1         sh     FAILED 2020-05-27T07:49:18 
                  extern  COMPLETED 2020-05-27T07:49:18 
                    bash     FAILED 2020-05-27T07:49:41 
                   a.out  COMPLETED 2020-05-27T07:52:31 
     user1         sh  COMPLETED 2020-05-27T08:28:34 
                  extern  COMPLETED 2020-05-27T08:28:34 
                    bash  COMPLETED 2020-05-27T08:28:42 
     user1         sh    TIMEOUT 2020-05-27T08:51:43 
                  extern  COMPLETED 2020-05-27T08:51:43 
                    bash  COMPLETED 2020-05-27T08:51:52     
    ```

We can retrieve historical data for any given user. For example if you want
to filter jobs by Start Time `2020-05-20` and End Time `2020-05-27` for user `elvis` 
you can do the following

??? example "sacct format example with Start and End Date"

    ```console
    $ sacct -u elvis -S 2020-05-20 -E 2020-05-27
           JobID    JobName  Partition    Account  AllocCPUS      State ExitCode 
    ------------ ---------- ---------- ---------- ---------- ---------- -------- 
    30922369     test_node+     system     physics       8256    TIMEOUT      0:0 
    30922369.ba+      batch                physics         64  CANCELLED     0:15 
    30922369.ex+     extern                physics       8256  COMPLETED      0:0 
    30922369.0   test_node+                physics        320     FAILED      1:0 
    30922369.1   test_node+                physics       1904     FAILED      1:0 
    30922378     test_node+     system     physics         38    PENDING      0:0 
    ```

 You can retrieve up to 31 days of job records within given time window, this was 
 implemented as safe measure to avoid bringing down slurmdb. You may notice this 
 error if you exceed the 31 day count
 
```shell 
$ sacct --start 2021-01-04 
       JobID    JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
sacct: error: slurmdbd: Too wide of a date range in query
$ date
Thu Feb  4 14:12:41 PST 2021
```

If you want to query by job states you can use `-s` or long option `--state` 
with state name. For complete list of job states see [JOB STATE CODES](https://slurm.schedmd.com/sacct.html#lbAG) 
in sacct manual. In example below we will query all fail jobs. You must use 
a start and end window using `--start` and `--end` option to report job states.

??? example "sacct example with user, format fields and job states"

    ```console
    $ sacct -X --format=User,JobName,State -s f --start=2021-02-01 --end=now 
         User    JobName      State 
    --------- ---------- ---------- 
     elvis   81932_161+     FAILED 
     elvis   82105_161+     FAILED 
    ```

If you want to filter output by JobID you can specify the `-j` option with a list
of comma separated job ids.

??? example "sacct filter by jobs"

    ```console    
    $ sacct -j 31170188,31171781
           JobID    JobName  Partition    Account  AllocCPUS      State ExitCode 
    ------------ ---------- ---------- ---------- ---------- ---------- -------- 
    31170188             sh interacti+     nstaff        272     FAILED      1:0 
    31170188.ex+     extern                nstaff        272  COMPLETED      0:0 
    31170188.0         bash                nstaff          1     FAILED      1:0 
    31170188.1        a.out                nstaff        272  COMPLETED      0:0 
    31171781             sh       resv     nstaff        272  COMPLETED      0:0 
    31171781.ex+     extern                nstaff        272  COMPLETED      0:0 
    31171781.0         bash                nstaff          1  COMPLETED      0:0 
    ```

`sacct` will query job from the default slurm cluster (`cori`),
however one can query jobs from a remote slurm cluster such as `escori` using the 
`--clusters=<clustername>` option or short option `-M <clustername>`. 

!!!note
    
    JobID are unique to each slurm cluster
    
??? example "query jobs from a slurm cluster"

    ```console
    $ sacct -X --format JobID,Cluster
           JobID    Cluster 
    ------------ ---------- 
    34789454           cori 
    34790830           cori 
    34791745           cori 
    34792974           cori 
    34792988           cori 
    
    $ sacct -X  -M escori --format JobID,Cluster
           JobID    Cluster 
    ------------ ---------- 
    1066624          escori 
    1066641          escori 
    1066847          escori 
    1066849          escori     
    ```
