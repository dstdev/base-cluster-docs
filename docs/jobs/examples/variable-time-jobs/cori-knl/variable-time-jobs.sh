#!/bin/bash
#SBATCH -J vtj
#SBATCH -q flex
#SBATCH -C knl 
#SBATCH -N 2
#SBATCH --time=48:00:00
#SBATCH --time-min=2:00:00 #the minimum amount of time the job should run
#SBATCH --error=%x-%j.err
#SBATCH --output=%x-%j.out
#SBATCH --mail-user=elvis@nersc.gov
#
#SBATCH --comment=96:00:00  #desired time limit
#SBATCH --signal=B:USR1@60  #sig_time (60 seconds) should match your checkpoint overhead time
#SBATCH --requeue
#SBATCH --open-mode=append

# specify the command to use to checkpoint your job if any (leave blank if none)
ckpt_command=

# requeueing the job if reamining time >0 (do not change the following 3 lines )
. /usr/common/software/variable-time-job/setup.sh
requeue_job func_trap USR1
#

# user setting goes here
export OMP_PROC_BIND=true
export OMP_PLACES=threads
export OMP_NUM_THREADS=4

#srun must execute in the background and catch the signal USR1 on the wait command
srun -n32 -c16 --cpu_bind=cores ./a.out &

wait

