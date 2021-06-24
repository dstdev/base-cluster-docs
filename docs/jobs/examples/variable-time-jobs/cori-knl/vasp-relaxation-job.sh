#!/bin/bash 
#SBATCH -J vt_vasp 
#SBATCH -q regular 
#SBATCH -C knl 
#SBATCH -N 2 
#SBATCH --time=48:0:00 
#SBATCH --error=%x%j.err 
#SBATCH --output=%x%j.out 
#SBATCH --mail-user=elvis@nersc.gov 
# 
#SBATCH --comment=96:00:00 
#SBATCH --time-min=02:0:00 
#SBATCH --signal=B:USR1@300 
#SBATCH --requeue 
#SBATCH --open-mode=append 
  
# user setting
module load vasp/20181030-knl 

export OMP_NUM_THREADS=4 
#srun must execute in background and catch signal on wait command 
srun -n 32 -c16 --cpu_bind=cores vasp_std & 
  
# put any commands that need to run to prepare for the next job here 
ckpt_vasp() { 
restarts=`squeue -h -O restartcnt -j $SLURM_JOB_ID` 
echo checkpointing the ${restarts}-th job >&2 
  
#to terminate VASP at the next ionic step 
echo LSTOP = .TRUE. > STOPCAR 

#wait until VASP to complete the current ionic step, write out WAVECAR file and quit 
srun_pid=`ps -fle|grep srun|head -1|awk '{print $4}'` 
echo srun pid is $srun_pid  >&2 
wait $srun_pid 
  
#copy CONTCAR to POSCAR 
cp -p CONTCAR POSCAR 
} 
  
ckpt_command=ckpt_vasp 

# requeueing the job if remaining time >0 
. /usr/common/software/variable-time-job/setup.sh 
requeue_job func_trap USR1 
  
wait

