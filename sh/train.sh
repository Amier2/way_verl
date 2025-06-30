export WANDB_API_KEY=78f4d41c22a2f65a50a25ea16624e0c6911ebf3b
export VLLM_ATTENTION_BACKEND=XFORMERS

DATA_DIR_PATH=data
RUN_ID=7B
GPU_ENV=4GPU
MODEL_ENV=Qwen/Qwen2.5-Coder-3B-Instruct
PROJECT_NAME=nl2sql

LOG_PATH=logs/$PROJECT_NAME
# MODEL_PATH=models/$MODEL_ENV
MODEL_PATH=$MODEL_ENV
EXPERIMENT_NAME=$GPU_ENV-$MODEL_ENV-$RUN_ID

mkdir -p $LOG_PATH

set -x

nvidia-smi

python -m verl.trainer.main_ppo \
    algorithm.adv_estimator=grpo \
    data.train_files=$DATA_DIR_PATH/train.parquet \
    data.val_files=$DATA_DIR_PATH/test.parquet \
    data.train_batch_size=2 \
    data.val_batch_size=2 \
    data.max_prompt_length=4096  \
    data.max_response_length=2048  \
    actor_rollout_ref.model.path=$MODEL_PATH \
    actor_rollout_ref.actor.optim.lr=3e-7 \
    actor_rollout_ref.model.use_remove_padding=True \
    actor_rollout_ref.actor.ppo_mini_batch_size=4 \
    actor_rollout_ref.actor.ppo_micro_batch_size=4 \
    actor_rollout_ref.actor.use_kl_loss=True \
    actor_rollout_ref.actor.kl_loss_coef=0.001 \
    actor_rollout_ref.actor.kl_loss_type=low_var_kl \
    actor_rollout_ref.model.enable_gradient_checkpointing=True \
    actor_rollout_ref.model.lora_rank=32\
    actor_rollout_ref.model.lora_alpha=0.5\
    actor_rollout_ref.rollout.load_format=safetensors\
    actor_rollout_ref.model.target_modules=all-linear\
    actor_rollout_ref.model.use_shm=True\
    actor_rollout_ref.rollout.layered_summon=True\
    actor_rollout_ref.actor.fsdp_config.param_offload=True \
    actor_rollout_ref.actor.fsdp_config.grad_offload=True \
    actor_rollout_ref.actor.fsdp_config.optimizer_offload=False \
    actor_rollout_ref.rollout.log_prob_micro_batch_size=16 \
    actor_rollout_ref.rollout.tensor_model_parallel_size=4 \
    actor_rollout_ref.rollout.name=vllm \
    actor_rollout_ref.rollout.gpu_memory_utilization=0.8 \
    actor_rollout_ref.rollout.n=4 \
    actor_rollout_ref.rollout.temperature=1.0 \
    actor_rollout_ref.ref.log_prob_micro_batch_size=16 \
    actor_rollout_ref.ref.fsdp_config.param_offload=True \
    algorithm.kl_ctrl.kl_coef=0.001 \
    trainer.critic_warmup=0 \
    trainer.logger=['wandb'] \
    trainer.project_name=$PROJECT_NAME \
    trainer.experiment_name=$EXPERIMENT_NAME \
    trainer.n_gpus_per_node=4 \
    trainer.nnodes=1 \
    trainer.default_local_dir=$LOG_PATH/$EXPERIMENT_NAME \
    trainer.default_hdfs_dir=null \
    trainer.save_freq=100 \
    trainer.test_freq=100 \
    trainer.total_epochs=5 $@ 2>&1 | tee $LOG_PATH/$MODEL_ENV/grpo.log