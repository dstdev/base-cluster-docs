# Troubleshooting Slurm

??? "How do I find which Slurm accounts I am part of?"    
     
   
    In this example, the current user is part of two accounts `nstaff` and `m3503`.  
    
    ```console
    $ iris
    Project      Used(user)    Allocated(user)        Used    Allocated
    ---------  ------------  -----------------  ----------  -----------
    m3503               0.0          1000000.0     12726.1    1000000.0
    nstaff          21690.5          4000000.0  26397725.1   80000000.0
    ```        

??? "What is my default Slurm account?"
    
     
??? "My job will terminate because it will exceed queue run time limit, what can I do?"
    
    If your job terminates due to queue run limit, you have a few options: 
    
    1. Optimize your workflow by profiling your code. We have several profiling tools including **HPCToolkit**, 
       **CrayPAT**, **MAP**, **Intel VTune**, **Parallelware Trainer**.  For more details on profilers see 
       [performance tools](../tools/performance/index.md) page
    2. Increase Node/Processor count to reduce runtime. 
    3. Utilize checkpoint/restart via [DMTCP](../development/checkpoint-restart/dmtcp/index.md)
    4. If all else fails, request a  [reservation](reservations.md)  
        
??? "What is a Slurm multi-cluster mode?"
    
    
    ```
    module load esslurm
    ```
    
    !!! note
    
    The default Slurm binaries are in `/usr/bin` but we place
    Slurm binaries for esslurm (i.e., `sbatch`, `squeue`, `sacct`, `srun`) in
    `/opt/esslurm/bin`. Once you load the module *your* `sbatch` should be the
    following:
    
    ```
    ```

??? "How do I monitor a job that I submitted?"  




                
??? "Unable to submit jobs to premium queue?"

??? "Why is my job marked as `InvalidQOS`?"

    This indicates you have specified incorrect qos name `#SBATCH -q <QOS>` in your job-script. Please
    check our [queue policy](policy.md) for list of available queues and correct
    your job script.
    
    If your account incurs a negative balance, your project will be restricted to **overrun** and **xfer** queue. 
    Take for example, project `m0001` has a negative balance since it used 75,000 node hours whereas the
    project limit was 50,000. We can check this using `iris` command.
    
    ```console
    Project      Used(user)    Allocated(user)       Used    Allocated
    ---------  ------------  -----------------  ---------  -----------
    m0001***      750000.0          50000.0     750000.0    50000.0
    *   = user share of project Negative
    **  = project balance negative
    *** = user and project balance negative
    ```
    
    Due to this change, project `m0001` will be restricted to subset of queues, if you have previously run jobs 
    on default queues (`debug`, `flex`, `regular`), your jobs will be stuck indefinitely and you should consider killing
    the jobs using [scancel](monitoring.md#cancel-jobs). 
    
## Cannot Submit Jobs


## Common Errors With Jobs

Some common errors encountered during submit or run times
and their possible causes are shown in the following table.

### Job submission errors

-   Error message:

    ```
    sbatch: error: Your account has exceeded a file system quota and is not permitted to submit batch jobs.  Please run `myquota` for more information.
    ```

    Possible causes/remedies:

    Your file system usage is over the quota(s). Please run the
    `myquota` command to see which quota is exceeded. Reduce usage
    and resubmit the job.

-   Error message:

    ```
    sbatch: error: Job request does not match any supported policy.
    sbatch: error: Batch job submission failed: Unspecified error.
    ```

    Possible causes/remedies:

    There is something wrong with your job submission parameters
    and the request (the requested number of nodes, the walltime
    limit, etc.) does not match the policy for the selected qos.
    Please check the [queue policy](policy.md).

    This error also happens when the job submission didn't include
    the `--time-min` line with the `flex`.

-   Error message:

    ```
    sbatch: error: More resources requested than allowed for logical queue shared (XX requested core-equivalents > YY)
    sbatch: error: Batch job submission failed: Unspecified error
    ```

    Possible causes/remedies:

    The number of logical cores that your job tries to use exceeds
    the the number that you requested for this `shared` qos job.

-   Error message:

    ```
    Job submit/allocate failed: Unspecified
    ```

    Possible causes/remedies:

    This error could happen if a user has no active SLU project on
    Aries  Please make sure your SLU account is renewed with an
    active allocation.
    .  Please make sure your SLU account is renewed with an
    active allocation.

-   Error message:

    ```
    Job submit/allocate failed: Invalid qos specification
    ```

    Possible causes/remedies:

    This error mostly happens if a user has no access to certain
    Slurm qos.  For example, a user who doesn't have access to the
    `realtime` qos would see this error when submitting a job to
    the qos.

-   Error message:

    ```
    sbatch: error: Batch job submission failed: Socket timed out on send/recv operation
    ```

    Possible causes/remedies:

    The job scheduler is busy. Some users may be submitting lots
    of jobs in a short time span. Please wait a little bit before
    you resubmit your job.

    This error normally happens when submitting a job, but can
    happen during runtime, too.

-   Error message:

    ```
    ```

    Possible causes/remedies:

    The interactive job could not start within 6 minutes, and,
    therefore, was cancelled. It is because either the number of
    available nodes left from all the reserved interactive nodes or
    out of the 64 node limit per     This error could happen if a user has no active SLU project on
    Aries. Please make sure your SLU  account is renewed with an
    active allocation.
    Please make sure your SLU account is renewed with an
    active allocation.

-   Error message:

    ```
    sbatch: error: No architecture specified, cannot estimate job costs.
    sbatch: error: Batch job submission failed: Unspecified error
    ```

    Possible causes/remedies:

    Your job didn't specify the type of compute nodes. To run on
    Haswell nodes, add to your batch script:

    ```
    #SBATCH -C haswell
    ```

    To request KNL nodes, add this line:

    ```
    #SBATCH -C knl
    ```

-   Error message:


### Runtime errors

-   Error message:

    ```
    srun: error: eio_handle_mainloop: Abandoning IO 60 secs after job shutdown initiated.
    ```

    Possible causes/remedies:

    Slurm is giving up waiting for stdout/stderr to finish. This
    typically happens when some rank ends early while others are
    still wanting to write. If you don't get complete stdout/stderr
    from the job, please resubmit the job.

-   Error message:

    ```
    Tue Jul 17 18:04:24 2018: [PE_3025]:_pmi_mmap_tmp: Warning bootstrap barrier failed: num_syncd=3, pes_this_node=68, timeout=180 secs
    ```

    Possible causes/remedies:

    Use the `sbcast` command to transmit the executable to all
    compute nodes before a srun command. For more information
    on `sbcast`, click [here](best-practices.md#large-jobs).

-   Error message:

    ```
    slurmstepd: error: _send_launch_resp: Failed to send RESPONSE_LAUNCH_TASKS: Resource temporarily unavailable
    ```

    Possible causes/remedies:

    This situation does not affect the job. This issue may have been fixed.

[comment]: <> (-   Error message:)
[comment]: <> ()
[comment]: <> (    ```)
[comment]: <> (    libgomp: Thread creation failed: Resource temporarily unavailable)
[comment]: <> (    ```)
[comment]: <> ()
[comment]: <> (    Possible causes/remedies:)
[comment]: <> ()




