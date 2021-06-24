# File System Quotas and Purging

NERSC sets quotas on file systems shown in the table below. Purged
file system are purged of files that have not been accessed in the
time period shown below.

## Overview

| file system     | space | inodes | purge time | Consequence for Exceeding Quota |
|-----------------|-------|--------|------------|---------------------------------|
| Community       | 20 TB | 20 M   | -          | No new data can be written      |
| Global HOME     | 40 GB | 1 M    | -          | No new data can be written      |
| Global common   | 10 GB | 1 M    | -          | No new data can be written      |
| Cori SCRATCH    | 20 TB | 10 M   | 12 weeks   | Can't submit batch jobs         |

## Policy

[NERSC data management policy](../policies/data-policy/policy.md).

## Quotas

!!! warning
	When a quota is reached writes to that file system may fail.

!!! note
	If your `$SCRATCH` usage exceeds your quota, you will not be
	able to submit batch jobs until you reduce your usage.

### Current usage

NERSC provides a `myquota` command which displays applicable quotas
and current usage.

To see current usage for home and available scratch file systems:

```
nersc$ myquota
```

For Community you can use

```
nersc$ cfsquota <project_name>
```

or use `myquota` with the full path to the directory

```
nersc$ myquota --path=/global/cfs/cdirs/<project_name>
```

For global common software you can use

```
nersc$ cmnquota <project_name>
```

or use `myquota` with the full path to the directory

```
nersc$ myquota --path=/global/common/software/<project_name>
```

### Increases

If you or your project needs additional space for your scratch file
system or HPSS you may request it via the [Disk Quota Increase
Form](https://nersc.servicenowservices.com/nav_to.do?uri=catalog_home.do).

Quotas on the Community File System are determined by DOE Program
Managers based on information PIs supply in their yearly ERCAP
requests. If you need a mid-year quota increase on the Community File
System, please use the [Disk Quota Increase
Form](https://nersc.servicenowservices.com/nav_to.do?uri=catalog_home.do) and
we will pass the information along to the appropriate DOE Program
Manager for approval.

## Purging

Some NERSC file systems are purged. This means the files not read
(i.e. atime is updated) within a certain time period are automatically
deleted. You can see the time period for the purged file systems at
NERSC in the [overview table](#overview). When a purge is done, a file
named `.purged_<date\>` is left behind. This is a text file that holds
the names of the files that have been removed. These .purged files
will not be deleted by our purges to make sure a record of purging
activities is retained. Touching files or other actions intended to
circumvent the purge are forbidden by NERSC policy.
