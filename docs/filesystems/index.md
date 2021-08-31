# File System overview

## Summary

File systems are configured for different purposes. Each machine has
access to at least three different file systems with different levels
of performance, permanence and available space.

| file system     | snapshots | backup | purging | access          |
|-----------------|-----------|--------|---------|-----------------|
| Community       | yes       | no     | no      | repository      |
| home            | yes       | yes    | no      | user            |
| common          | no        | no     | no      | repository      |
| HPSS            | no        | no     | no      | user            |

!!! note
	See [quotas](quotas.md) for detailed information about inode,
	space quotas and file system purge policies.

## Global storage

### [Global Home](global-home.md)

Permanent, relatively small storage for data like source code, shell
scripts that you want to keep. This file system is not tuned for high
performance for parallel jobs. Referenced by the environment variable
`$HOME`.

### [Common](global-common.md)

A performant platform to install software stacks and compile
code. Mounted read-only on compute nodes.

### [Community](community.md)

Large, permanent, medium-performance file system. Community directories
are intended for sharing data within a group of researchers.

### [Archive](archive.md) (HPSS)


The High Performance Storage System (HPSS) is a modern, flexible,
performance-oriented mass storage system. HPSS is intended for long term
storage of data that is not frequently accessed.

## Local storage


