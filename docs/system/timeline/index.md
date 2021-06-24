# Cori Timeline

This page records a brief timeline of significant events and user
environment changes on Cori (in reverse chronological order).  Please
also refer to the [detailed history of Cori PE software default
versions](default_PE_history/PE_history.md).

## May 19-20, 2021

Enabled "compile" QOS for all users.
Software upgrade (NEO 3.5) for Cori scratch file system.

## Apr 21, 2021

Added “flex” QOS for Cori Haswell with the charging discount of 50%.  
Regular Haswell jobs larger than 512 nodes now require reservation.

## Jan 20, 2021

New Allocation year starts.

"premium" QOS is not available by default for all users. PIs need to 
manually authorize individual users to use "premium". The charge factor 
for "premium" will double (from 2x of "regular" QOS to 4x) once a project 
has used 20% of its allocation on "premium".

Python pip in the default Python module (python/3.8-anaconda-2020.11) 
and Python3 module (an alias to the default Python module) is changed 
by prepending PYTHONUSERBASE/bin to PATH.

## Nov 18, 2020

Programming Environment changes include new software available
(CDT/20.10 and intel/19.1.2.254) and old software removal (CDT/20.03)
after scheduled maintenance.  Detailed lists can be found
[here](default_PE_history/2020Nov.md).

## Aug 19, 2020

Default setting for adaptive routing on the aries network (the
environment variable setting of MPICH_GNI_ROUTINE_MODE) is changed
from ADAPTIVE_0 (least bias towards minimal) to ADAPTIVE_3 (high
minimal bias) for the benefit of the majority of NERSC workloads. More
details can be found [here](../../../performance/network.md).

## Jul 10-13, 2020 

NERSC power upgrade.

Programming Environment changes include new software available
(CDT/20.06) and old software removal (CDT/19.06) after scheduled
maintenance.  Detailed lists can be found
[here](default_PE_history/2020Jul.md).
   
Memory limit (128 GB on login nodes and workload nodes, 42 GB on
Jupyter nodes) and CPU limit (50% CPU on login nodes, workload nodes,
and Jupyter nodes) on a per-user basis are in place.

Slurm updated from version 19.05.5 to 20.02.3. Slurm 20.02 brings
fixes, performance improvements, and new capabilities designed by
NERSC to better integrate experimental facility workloads.

Software upgrade (NEO 3.4) for Cori scratch file system.

## Apr 22, 2020
   
Software upgrade (NEO 3.2) for Cori scratch file system.
   
Programming Environment changes include new software available
(CDT/20.03) after scheduled maintenance. New intel versions 19.0.8.324
and 19.1.0.166 have already been installed as of Apr 1. Detailed lists
can be found [here](default_PE_history/2020Apr.md).
   
VTune default version change (from 2019.up3 to 2020).
   
## Feb 21 - 24, 2020

NERSC power upgrade. 
   
Dotfiles setup change to more standard Linux system settings.  User
dotfiles are no longer symlinks to NERSC-defined dotfiles.

## Jan 17, 2020

Community File System (CFS) is available as a fully functional file
system with general read/write access on Cori, the data transfer
nodes, the science gateways, and Spin.

## Jan 14, 2020

SW default change to CDT 19.11 after scheduled maintenance at the
Allocation Year Transition.  Dynamic linking becomes default.  Please
see the detailed list [here](default_PE_history/2019Dec-2020Jan.md).
   
New charge factors for Haswell (140, increase from 90) and KNL (80,
decrease from 90).
   
Python 2 retires, Python 3 becomes default.
  
Community File System data sync begins. 
   
Slurm updated from version 19.05.3 to 19.05.5. Configuration changes
made to help with the performance of LDAP queries and to give more
SLURM a little more time to evaluate the system and queues so it can
make better informed scheduling decisions。

## Dec 5-6, 2019

OS upgrade from CLE7.0UP00 to CLE7.0UP01.
    
Programming Environment changes include new software available
(CDT/19.11) after scheduled maintenance. Detailed lists can be found
[here](default_PE_history/2019Dec-2020Jan.md).

## Sept 10-12, 2019

Lustre file system (ClusterStor) upgrade from NEO2 to NEO3.1.

## Jul 29, 2019

Large jobs discount for job use 1,024 or more KNL nodes increased from
40% to 50%.

## Jul 26-30, 2019

NERSC power upgrade, Cori OS upgrade from CLE6.0UP07 to CLE7.0UP00.

Slurm upgrade from 18.08 to 19.05.
     
Programming Environment changes include new default versions
(CDT/19.03, intel/19.0.3.199), old software removals (CDT/18.03,
CDT/18.09, CDT/18.12), and new software available (CDT/19.06). Also,
craype-hugepages2M is loaded by default. Detailed lists can be found
[here](default_PE_history/2019Jul.md).

## Jun 10, 2019

"flex" QOS jobs discount decreased from 100% (i.e., free) to 75%.
"low" QOS jobs discount decreased from 50% to 25%.
 
## Apr 23, 2019

Added "flex" QOS for Cori KNL, and free of charge.

## Apr 10, 2019

Programming Environment changes include old software removals
(CDT/17.09), and new software available (CDT/19.03 and
intel/19.0.3.199) after scheduled maintenance. Detailed lists can be
found [here](default_PE_history/2019Apr.md).

## Mar 14, 2019

Large jobs discount for job use 1,024 or more KNL nodes increased from
20\% to 40\%.

## Feb 13, 2019

Added "low" QOS for Cori KNL. 

## Jan 8, 2019

Programming Environment changes include new default versions
(CDT/18.12), old software removals (CDT/18.06), and new software
available (CDT/18.12) after scheduled maintenance at the Allocation
Year Rollover. Detailed lists can be found
[here](default_PE_history/2019Jan.md).

New charge factors for Haswell (90, increase from 80) and KNL (90,
decrease from 96).

## Oct 17, 2018

Slurm upgrade from 17.11 to 18.08.

## Sept 19, 2018

OS upgrade from CLE6.0UP05 to CLE6.0UP07. 
 
Programming Environment changes include old software removals
(CDT/17.12), and new software available (CDT/18.09 and
intel/18.0.3.222) after scheduled maintenance. Detailed lists can be
found [here](default_PE_history/2018Sep.md).

## Jul 11, 2018

Programming Environment changes include new default versions
(CDT/18.03), old software removals (CDT/17.06), and new software
available (CDT/18.06) after scheduled maintenance. Detailed lists can
be found [here](default_PE_history/2018Jul.md).

## May 8-9, 2018     

OS upgrade from CLE6.0UP04 to CLE6.0UP05.  
 
VTune default change to 2018.up2.

## Jan 9, 2018

Slurm upgrade from 17.02 to 17.11. Users need only specify a QOS in
batch scripts instead of a partition.
  
Intel default version changed from 18.0.0.128 to 18.0.1.163.  SW
default change to CDT 17.09 after scheduled maintenance.  Please see
the detailed list [here](default_PE_history/PE_history.md).

## Nov 7, 2017

Cori accepted.

## Oct 6-9, 2017

Maintenance on the EPO (Emergency Power Off) and water system for the
large systems.
  
Intel default version changed from 17.0.2.174 to 18.0.0.128.

## Aug 8-10, 2017     

OS upgrade from CLE6.0UP03 to CLE6.0UP04.  
 
SW default change to CDT 17.06 after scheduled maintenance.  Please
see the detailed list [here](default_PE_history/PE_history.md).

## Jul 1, 2017

Charging on Cori KNL begins. Large Jobs using 1,024 or more KNL nodes
receive 20\% charging discount.

## May 30, 2017

All users are enabled on Cori KNL without restriction.

## Apr 18 - Apr 21, 2017

Two new Haswell cabinets (384 compute nodes) added to the system.  The
new total number of Haswell nodes becomes 2,388.  The total number of
all nodes (2,388 Haswell plus 9,688 KNL) on Cori becomes 12,076.

## Mar 22 - Mar 24, 2017

OS upgrade from CLE6.0UP01 to CLE6.0UP03. Software default changes:
vtune from 2017.up01 to 2017.up02; perftools from 6.4.2 to 6.4.6.

## Mar 16, 2017

In order to work around an Intel compiler bug in versions 17.0.1.132
and 17.0.2.144, the default setting of Fortran buffered IO is turned
off, i.e.,(the environment variable of FORT_BUFFERED=1 has been
removed.

## Feb 28 - Mar 3, 2017

Two new KNL cabinets (384 compute nodes) added to the system.  The new
total number of KNL nodes becomes 9,688.  Slurm updated from version
16.05 to 17.02.

## Feb 6, 2017

Selected users' Cori scratch directories now managed by new Meta Data
Servers.

## Jan 30, 2017

Cori scratch is mounted on NERSC Data Transfer Nodes (DTNs) to allow
fast data moving between NERSC and other facilities.

## Dec 20, 2016

All users have access to Cori KNL.  Intel compiler default version
changed from 16.0.3.210 to 17.0.1.132.

## Nov 2016

Cori KNL access for NESAP teams.

## Nov 19, 2016

SW default change to CDT 16.10 after scheduled maintenance.  Please
see the detailed list [here](default_PE_history/PE_history.md).

## Sept 19 - Oct 31, 2016

Cori Haswell and KNL cabinets integration. Haswell nodes returned to
users on Oct 31.

Running jobs changed for getting optimal process and thread
affinity. Use sun "-c" and "--cpu_bind=cores" when needed. Also
enforce "-C haswell" to requrest Haswell nodes.

## Jul 20, 2016

Cori $SCRATCH is available as $CSCRATCH on Cori and Edison.

## Jul 2016

Cori KNL cabinets arrival.  First cabinets arrived on July 13.

## Jul 4, 2016

Introduced SLURM file license features.

## Jun 13 - 30, 2016

OS upgrade to Rhine/Redwood (CLE6) to prepare for KNL arrival.  SW
default change to CDT 16.06 after CRT power outage.  Please see the
detailed list [here](default_PE_history/PE_history.md).

## May 20, 2016

Burst Buffer on Cori Phase 1 accepted. 

## May 11, 2016
 
CUG Best Paper Award for Burst Buffer Early User Program

## May 9, 2016
 
"long" (1 node, 96-hr) job QOS available. 

## Mar 1, 2016
 
Scratch file system regular purge started.

## Mar 21, 2016
 
Cori Phase 1 compute nodes accepted.

## Feb 27, 2016
  
SW default change to CDT 16.01 after CRT power outage.  Please see the
detailed list [here](default_PE_history/PE_history.md).

## Jan 12, 2016
 
New allocation year AY16 starts. Cori usage starts charging.  New SSH
Key Authentication Mechanism became mandatory.

## Dec 4, 2015
 
"realtime" partition enabled.

## Nov 17, 2015
 
SSH host key changed to use 4096-bit new RSA key. Host based SSH
authentication works.

## Nov 11, 2015
 
Burst Buffer enabled for early users.

## Oct 29 - Nov 12, 2015
 
Early users were enabled in 7 phases. All users were enabled by Nov
12, 2015.

## Sept 29, 2015
 
Cori Phase 1 (along with Burst Buffer) delivered.
