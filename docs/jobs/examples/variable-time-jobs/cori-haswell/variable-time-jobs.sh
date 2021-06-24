#!/bin/bash
#SBATCH -J vtj 
#SBATCH -q regular
#SBATCH -C haswell
#SBATCH -N 2
#SBATCH --time=48:00:00
#SBATCH --time-min=2:00:00 #the minimum amount of time the job should run
#SBATCH --error=vtj-%j.err
#SBATCH --output=vtj-%j.out
#SBATCH --mail-user=elvis@nersc.gov
#
#SBATCH --comment=96:00:00  #desired timelimit
#SBATCH --signal=B:USR1@60
#SBATCH --requeue
#SBATCH --open-mode=append

# specify the command to run to checkpoint your job if any (leave blank if none)
ckpt_command=

# requeueing the job if reamining time >0 (do not change the following 3 lines )
. /usr/common/software/variable-time-job/setup.sh
requeue_job func_trap USR1
#

# user setting goes here

# srun must execute in the background and catch the signal USR1 on the wait command
srun -n64 -c2 --cpu_bind=cores ./a.out &

wait

