python scripts/model_merger.py merge \
    --backend fsdp \
    --local_dir logs/nl2sql/4GPU-models/Qwen2.5-3B-Instruct-3B/global_step_100/actor \
    --target_dir merged_hf_model