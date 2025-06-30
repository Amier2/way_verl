export CUDA_VISIBLE_DEVICES=0,1,2,3
export HF_ENDPOINT=https://hf-mirror.com
OUTPUT_FORMAT=json

MODEL_ENV=models/Qwen2.5-Coder-3B-Instruct # TODO: add model path
OUTPUT_FILE_NAME=generated_sql_base.$OUTPUT_FORMAT
DATASET=bird # [bird, spider, spider-dk, spider-syn, spider-realistic, spider2-lite]
MODE=dev # [dev, test], only spider has test mode
NUM_GPUS=4 

TEMPERATURE=0.8

N=1

if [ "$DATASET" = "spider" ]; then
    if [ "$MODE" = "test" ]; then
        INPUT_FILE=data/NL2SQL/Spider/test.json
        DATABASE_PATH=data/NL2SQL/Spider/test_database  
        OUTPUT_FILE=results/spidertest-$OUTPUT_FILE_NAME
        TABLE_VALUE_CACHE_PATH=data/NL2SQL/Spider/spidertest_db_id2sampled_db_values.json 
        TABLE_INFO_CACHE_PATH=data/NL2SQL/Spider/spidertest_db_id2db_info.json
    elif [ "$MODE" = "dev" ]; then
        INPUT_FILE=data/NL2SQL/Spider/dev.json
        DATABASE_PATH=data/NL2SQL/Spider/database
        OUTPUT_FILE=results/spiderdev-$OUTPUT_FILE_NAME
        TABLE_VALUE_CACHE_PATH=data/NL2SQL/Spider/spiderdev_db_id2sampled_db_values.json
        TABLE_INFO_CACHE_PATH=data/NL2SQL/Spider/spiderdev_db_id2db_info.json
    fi
elif [ "$DATASET" = "bird" ]; then
    if [ "$MODE" = "dev" ]; then
        INPUT_FILE=data/NL2SQL/BIRD/dev_20240627/dev.json
        DATABASE_PATH=data/NL2SQL/BIRD/dev_20240627/dev_databases
        OUTPUT_FILE=results/birddev-$OUTPUT_FILE_NAME
        TABLE_VALUE_CACHE_PATH=data/NL2SQL/BIRD/dev_20240627/bird_db_id2sampled_db_values.json
        TABLE_INFO_CACHE_PATH=data/NL2SQL/BIRD/dev_20240627/bird_db_id2db_info.json
    else
        exit 1
    fi
elif [ "$DATASET" = "spider-dk" ]; then
    if [ "$MODE" = "dev" ]; then
        INPUT_FILE=data/NL2SQL/Spider-DK/spiderdk_dev.json
        DATABASE_PATH=data/NL2SQL/Spider-DK/database
        OUTPUT_FILE=results/spiderdkdev-$OUTPUT_FILE_NAME
        TABLE_VALUE_CACHE_PATH=data/NL2SQL/Spider-DK/spiderdkdev_db_id2sampled_db_values.json
        TABLE_INFO_CACHE_PATH=data/NL2SQL/Spider-DK/spiderdkdev_db_id2db_info.json
    else
        exit 1
    fi
elif [ "$DATASET" = "spider-syn" ]; then
    if [ "$MODE" = "dev" ]; then
        INPUT_FILE=data/NL2SQL/Spider-Syn/spider_syn.json
        DATABASE_PATH=data/NL2SQL/Spider/database
        OUTPUT_FILE=results/spidersyn-$OUTPUT_FILE_NAME
        TABLE_VALUE_CACHE_PATH=data/NL2SQL/Spider/spiderdev_db_id2sampled_db_values.json
        TABLE_INFO_CACHE_PATH=data/NL2SQL/Spider/spiderdev_db_id2db_info.json
    else
        exit 1
    fi
elif [ "$DATASET" = "spider-realistic" ]; then
    if [ "$MODE" = "dev" ]; then
        INPUT_FILE=data/NL2SQL/Spider-Realistic/spider-realistic.json
        DATABASE_PATH=data/NL2SQL/Spider/database
        OUTPUT_FILE=results/spiderrealdev-$OUTPUT_FILE_NAME
        TABLE_VALUE_CACHE_PATH=data/NL2SQL/Spider/spiderdev_db_id2sampled_db_values.json
        TABLE_INFO_CACHE_PATH=data/NL2SQL/Spider/spiderdev_db_id2db_info.json
    else
        exit 1
    fi
elif [ "$DATASET" = "spider2-lite" ]; then
    if [ "$MODE" = "dev" ]; then
        INPUT_FILE=data/NL2SQL/Spider-Realistic/spider-realistic.json
        DATABASE_PATH=data/NL2SQL/Spider/database
        OUTPUT_FILE=results/spiderrealdev-$OUTPUT_FILE_NAME
        TABLE_VALUE_CACHE_PATH=data/NL2SQL/Spider/spiderdev_db_id2sampled_db_values.json
        TABLE_INFO_CACHE_PATH=data/NL2SQL/Spider/spiderdev_db_id2db_info.json
    else
        exit 1
    fi
else
    echo "Only support spider, bird, spdier-dk"
    exit 1
fi


python src/inference.py \
    --nl2sql_ckpt_path $MODEL_ENV \
    --dataset_name $DATASET \
    --input_file $INPUT_FILE \
    --output_file $OUTPUT_FILE \
    --database_path $DATABASE_PATH \
    --tensor_parallel_size $NUM_GPUS \
    --n $N \
    --temperature $TEMPERATURE \
    --output_format $OUTPUT_FORMAT \
    --table_value_cache_path $TABLE_VALUE_CACHE_PATH \
    --table_info_cache_path $TABLE_INFO_CACHE_PATH
