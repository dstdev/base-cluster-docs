# Reservations

Users can request a scheduled reservation of machine resources if
their jobs have special needs that cannot be accommodated through the
regular batch system. A reservation brings some portion of the machine
to a specific user or project for an agreed upon duration. Typically
this is used for interactive debugging at scale or real time
processing linked to some experiment or event.

!!! failure "Note"
	It is not intended to be used to guarantee fast throughput
	for production runs.

## Charging

For normal batch jobs, charging against a project's allocation is done
on a per job basis. For scheduled reservations the entire block of
reserved time is charged regardless of the number of nodes used or
time spent running jobs.

## Requesting a reservation

To reserve compute nodes, a request must be sent in with *at least 1 week*
notice.  Please ask for the least amount of resources you need
and try to schedule reservations so as to minimize impact on other
users. 


## Cancellations

Cancellation of a reservation must be done with a minimum of 4 days
notice. If you do not receive a confirmation that your
cancellation was received and it is less than 4 days until your

## Viewing reservations

To view all reservations run `scontrol show reservations`, the output will 
consist of one entry per reservation name that can be used with option 
`--reservation` to access the reservation. Take a close look at the reservation 
fields such as `StartTime` `EndTime`, `Duration`, `Nodes`,`Users`, `Accounts`  
to understand what the reservation. 

```
$ scontrol show reservations
ReservationName=knl_fp_test StartTime=2019-12-06T00:13:30 EndTime=2020-12-05T00:13:30 Duration=365-00:00:00
   Nodes=nid10240 NodeCnt=1 CoreCnt=68 Features=(null) PartitionName=(null) Flags=SPEC_NODES
   TRES=cpu=272
   Users=(null) Accounts=nstaff Licenses=(null) State=ACTIVE BurstBuffer=(null) Watts=n/a

ReservationName=dvstrace StartTime=2020-05-05T16:23:01 EndTime=2021-05-05T16:23:01 Duration=365-00:00:00
   Nodes=nid0[1571-1572] NodeCnt=2 CoreCnt=64 Features=haswell PartitionName=(null) Flags=
   TRES=cpu=128
   Users=(null) Accounts=nstaff Licenses=(null) State=ACTIVE BurstBuffer=(null) Watts=n/a

ReservationName=vESW_2020_Thurs StartTime=2020-06-04T09:00:00 EndTime=2020-06-04T12:00:00 Duration=03:00:00
   Nodes=nid00[786-792,794-831,845-859] NodeCnt=60 CoreCnt=1920 Features=haswell PartitionName=regular_hsw Flags=
   TRES=cpu=3840
   Users=(null) Accounts=ntrain Licenses=(null) State=INACTIVE BurstBuffer=(null) Watts=n/a

ReservationName=vESW_2020_Fri StartTime=2020-06-05T09:00:00 EndTime=2020-06-05T12:00:00 Duration=03:00:00
   Nodes=nid00[786-792,794-831,845-859] NodeCnt=60 CoreCnt=1920 Features=haswell PartitionName=regular_hsw Flags=
   TRES=cpu=3840
   Users=(null) Accounts=ntrain Licenses=(null) State=INACTIVE BurstBuffer=(null) Watts=n/a
```

In order to use a reservation, the system administrators will grant access to 
individual users or by accounts. To filter by reservation name you can do one of
the following

```bash
scontrol show reservations=<ReservationName>
scontrol show reservations <ReservationName>
```

Shown below is a summary for reservation `knl_fp_test`

```
$ scontrol show reservations=knl_fp_test 
ReservationName=knl_fp_test StartTime=2019-12-06T00:13:30 EndTime=2020-12-05T00:13:30 Duration=365-00:00:00
   Nodes=nid10240 NodeCnt=1 CoreCnt=68 Features=(null) PartitionName=(null) Flags=SPEC_NODES
   TRES=cpu=272
   Users=(null) Accounts=nstaff Licenses=(null) State=ACTIVE BurstBuffer=(null) Watts=n/a
```

The `knl_fp_test` reservation is accessible to all users belonging 
to the `nstaff` account because `Accounts=nstaff` is set even though no users 
are defined `Users=(null)`. If you notice an error in your reservation, please 
reach out to us in order to make a correction. Take note of all fields listed
in the reservation to ensure we have allocated the resources that matches your 
request.

Shown below we have a reservation `2005280700_TB_WS_HW_WORK` assigned to user 
`tbrewer`, however the reservation is no longer active since `State=INACTIVE`. 

```
$ scontrol show reservations 2005280700_TB_WS_HW_WORK
ReservationName=2005280700_TB_WS_HW_WORK StartTime=2020-05-28T07:00:00 EndTime=2020-05-29T14:00:00 Duration=1-07:00:00
   Nodes=nid0[0676-0679,1324-1327] NodeCnt=8 CoreCnt=256 Features=(null) PartitionName=(null) Flags=SPEC_NODES
   TRES=cpu=512
   Users=tbrewer Accounts=(null) Licenses=(null) State=INACTIVE BurstBuffer=(null) Watts=n/a
```

## Using a reservation

Once your reservation request is approved and a reservation is placed
on the system, to run jobs in the reservation, you can use the 
`--reservation` option on the command line:

```
```

or add `#SBATCH --reservation=<reservation_name>` to your job script.

!!! note
	It is possible to submit jobs to a reservation once it is
	*created* - jobs will start immediately when the reservation is
	available.

### KNL mode changes

!!! warning
	KNL reboots can take up to 1 hour.

KNL nodes are configured as quad,cache by default. If you have
requested a reservation with a different mode you will be responsible
for rebooting the nodes into the proper mode and should account for
this in your request.

!!! note
	Additional demonstration of need may be required for large scale
	reservations requesting reboots as system administrators are
	needed to assist in the reboot.

It is recommended to submit a "test" job at the start of your
reservation to reboot the nodes.

```shell
```

!!! danger
	If you forget to put the correct `-C` option on **all** of your jobs
	**you may lose 2 hours of your reservation** to reboots.

## Ending a reservation

All running jobs under a reservation will be terminated when the
reservation ends. There are two ways to end a reservation earlier 
than scheduled:

* When requesting the reservation, you can ask us to activate a 
setting that will terminate the reservation a few minutes after 
all jobs in the reservation queue have completed.

