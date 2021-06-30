# NERSC Help and Support

NERSC strives to be the most user friendly supercomputing center in
the world.

## FAQ

* [Password Resets](../accounts/passwords.md#forgotten-passwords)
* [Connection problems](../connect/index.md#ssh)
* [File Permissions](../filesystems/unix-file-permissions.md)

## Help Desk

The [online help desk](https://help.nersc.gov/) is the **preferred**
method for contacting NERSC.

!!! attention
	NERSC Consultants handle thousands of support requests per
	year. In order to ensure efficient timely resolution of issues
	include **as much of the following as possible** when making a
	request:

	* error messages
	* jobids
	* location of relevant files
	     * input/output
	     * job scripts
	     * source code
	     * executables
	* output of `module list`
	* any steps you have tried
	* steps to reproduce

!!! tip
    You can make code snippets, shell outputs, etc in your ticket much more 
    readable by inserting a line with:
    ```
    [code]<pre>
    ```
    before the snippet, and another line with:
    ```
    </pre>[/code]
    ```
    after it. (For a full list of formatting options, see 
    [this ServiceNow article](https://community.servicenow.com/community?id=community_blog&sys_id=4d9ceae1dbd0dbc01dcaf3231f9619e1))

Access to the online help system requires logging in with your NERSC username,
password, and one-time password. If you are an existing user unable to log in,
you can send an email to <accounts@nersc.gov> for support.

If you are not a NERSC user, you can reach NERSC with your queries at
<accounts@nersc.gov> or <allocations@nersc.gov>.

## Appointments with NERSC User-Support Staff

We provide 25-minute appoinments with NERSC user support consultants. These can
be scheduled [here](https://nersc.as.me). The range of available topics are
described below. To make the most use of an appointment, we highly encourage
you to try some things on your own and share them with NERSC staff ahead of
time using the appointment intake form.

!!! attention
    Appointments use Google Hangouts for video conferencing. If you are using
    Google Chrome, please make sure that the “enable screen share” Security
    setting is enabled.

### NERSC 101

This category is good for basic questions, and you could not find the answer in
our documentation. Or when you just don't know where to start.

### KNL Optimization

Advice on how to optimize code and compilers to make use of the KNL compute
nodes on Cori. Possible discussion topics include:

1. Compiling code
2. Thread affinity
3. Batch script setup
4. Profiling your code
5. Refactoring your code

### Containers at NERSC

Advice on deploying containerized workflows at NERSC using Shifter. We
recommend that you share your Dockerfile, the image name (after downloading it
to Cori using `shifterimg`) before the appointment if possible.

### NERSC Filesystems

Advice on I/O optimization and Filesystems at NERSC. Possible discussion topics
include:

1. Optimal file system choices
2. Quota and file-permission issues
3. I/O profiling
4. Refactoring your code

### GPU Basics

Advice on programming GPUs for users that are new to the topic. This category
is good for when you have started developing your GPU code, but are
encountering problems.

### Using GPUs in Python

Advice on how to use GPUs from Python, eg. `CuPy`, `RAPIDS`, or `PyCUDA`.

### Checkpoint/Restart using MANA

Advice on how to use MANA to enable automatic
[checkpoint/restart](../development/checkpoint-restart) in MPI applications.

## Phone support

**Consulting and account-support phone services have been suspended.**

To report an urgent system issue, you may call NERSC at 1-800-66-NERSC
(USA) or 510-486-8600 (local and international).
