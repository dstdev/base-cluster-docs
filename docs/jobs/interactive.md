# Interactive Jobs

## Allocation

[`salloc`](index.md#salloc) is used to allocate resources in real
time to run an interactive batch job. Typically this is used to 
allocate resources and spawn a shell. The shell is then used to 
execute [`srun`](index.md#srun) commands to launch parallel tasks.

### "interactive" QOS on Perlmutter and Cori

Perlmutter and Cori have an dedicated interactive QOS. This queue
is intended to deliver nodes for interactive use within 6 minutes
of the job request.

We have deployed the QOS to support medium-length interactive work.
This queue is intended to deliver nodes for interactive use within
6 minutes of the job request. To access the interactive queue add
the qos flag to your salloc command.

```
salloc -N 1 -C gpu -G 4 -q interactive -t 01:00:00   # GPU nodes On Perlmutter

salloc -N 1 -C haswell  -q interactive -t 01:00:00   # Haswell nodes On Cori

salloc -N 1 -C knl      -q interactive -t 01:00:00   # KNL nodes On Cori
```

On Cori, users in this queue are limited to two jobs running job
on as many as 64 nodes for up to 4 hours. Additionally, each NERSC
allocation (MPP repo) is further limited to a total of 64 nodes
between all their interactive jobs (KNL or haswell). This means
that if UserA in repo m9999 has a job using 1 haswell node, UserB
(who is also in repo m9999) can have a simultaneous job using 63
haswell nodes or 63 KNL nodes, but not 64 nodes. Since this is
intended for interactive work, each user can submit only two jobs
at a time (either KNL or haswell). KNL nodes are currently limited
to quad,cache mode only. You can only run full node jobs; sub-node
jobs like those in the shared queue are not possible.

We have configured this queue to reject the job if it cannot be
scheduled within a few minutes. This could be because the job violates
the single job per user limit, the total number of nodes per NERSC
allocation limit, or because there are not enough nodes available to
satisfy the request. In some rare cases, jobs may also be rejected
because the batch system is overloaded and wasn't able to process your
job in time. If that happens, please resubmit.

Since there is a limit on number of nodes used per allocation on
Cori, you may be unable to run a job because other users who share
your allocation are using it. To see who in your allocation is using
the interactive queue on Cori, you can use

```
squeue --qos=interactive --account=<reponame> -O jobid,username,starttime,timelimit,maxnodes,account
```

If the number of nodes in use by your repo sums up to 64 nodes,
please contact the other group members if you feel they need to
release interactive resources.

You can see the number of nodes that in use (A for allocated) or idle
(I) using this command

```
cori$ sinfo -p interactive --format="%15b %8D %A"
ACTIVE_FEATURES NODES    NODES(A/I)
knl             2        0/0
haswell         192      191/1
knl,cache,quad  190      65/124
```

### Cori "debug" QOS

A number of Haswell and Cori compute nodes are reserved for the "debug" QOS, 
which has a designed quick turnaround time due to the short 30 min wall time
limit, the small max number of nodes limit (64 on Haswell, and 512 on KNL), 
and the small run limit (2 each on Haswell and KNL per user). 

The "debug" QOS is intended for code development, testing, and debugging.  
One of the common usages is to submit a batch interactive job via the
`salloc` command, such as:

```
cori$ salloc -N 32 -C haswell -q debug -t 20:00
```

When the requested debug nodes are available, it will land on the head 
compute node of the allocated compute nodes pool, and the `srun` command 
can be used to launch parallel tasks interactively.

To run debug jobs on KNL nodes, use `-C knl` instead of `-C haswell`.

You can only run full node jobs in the **debug** QOS; sub-node jobs like 
those in the **shared** queue are not possible.
