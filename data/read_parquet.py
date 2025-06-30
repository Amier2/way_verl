import pandas as pd

# 读取 parquet 文件
df = pd.read_parquet(
    'data/NL2SQL/BIRD/test.parquet',
    engine='pyarrow'  # 与保存时使用的引擎一致
)

# logger.info(f"成功读取 parquet 文件: {file}")
print()


# import ijson
# import json
# import os
# import random

# # 初始化每个难度的计数器和存储列表
# target_count = 50000
# difficulties = ['Simple', 'Moderate', 'Complex', 'Highly Complex']
# sampled_data = {difficulty: [] for difficulty in difficulties}
# current_object = {}
# key_stack = []
# object_count = 0

# # 获取文件大小
# file_path = 'data/NL2SQL/SynSQL-2.5M/data.json'
# file_size = os.path.getsize(file_path)

# # 使用蓄水池抽样算法
# def reservoir_sampling(sample_list, item, target_count):
#     if len(sample_list) < target_count:
#         sample_list.append(item)
#     else:
#         index = random.randint(0, len(sample_list))
#         if index < target_count:
#             sample_list[index] = item
#     return sample_list

# # 使用 ijson 流式解析
# with open(file_path, 'r') as f:
#     parser = ijson.parse(f)
#     for prefix, event, value in parser:
#         if event == 'start_map':
#             # 开始一个新的对象
#             current_object = {}
#             key_stack = []
#         elif event == 'end_map':
#             object_count += 1
#             # 完成一个对象的解析
#             if 'sql_complexity' in current_object:
#                 complexity = current_object['sql_complexity']
#                 if complexity in difficulties:
#                     if 'question_style' not in current_object or current_object['question_style'] != 'Multi-turn Dialogue':
#                         sampled_data[complexity] = reservoir_sampling(
#                             sampled_data[complexity], current_object, target_count
#                         )

#             # 计算已读字节数
#             read_bytes = f.tell()
#             progress = (read_bytes / file_size) * 100
#             print(f"\r已处理 {object_count} 个对象，进度: {progress:.2f}%", end="")
#         elif event == 'map_key':
#             # 记录当前键
#             key_stack.append(value)
#         elif event == 'string' or event == 'number' or event == 'boolean':
#             # 设置当前对象的属性值
#             current_key = ".".join(key_stack)
#             current_object[current_key] = value
#             key_stack.pop()
#     print()  # 换行

# # 合并所有抽样数据
# filtered_data = []
# for difficulty in difficulties:
#     filtered_data.extend(sampled_data[difficulty])

# # 将过滤后的数据保存为新的 JSON 文件
# with open('data/NL2SQL/SynSQL-2.5M/data_filtered.json', 'w') as outfile:
#     json.dump(filtered_data, outfile, indent=4)

# # 统计最终各难度的数量
# total_count = sum(len(sampled_data[difficulty]) for difficulty in difficulties)
# print(f"新生成的 JSON 文件中有 {total_count} 条数据。")
# for difficulty in difficulties:
#     print(f"{difficulty} 难度的数据有 {len(sampled_data[difficulty])} 条。")

# # 统计每个难度的 db_id 种类数量
# db_id_counts = {difficulty: set() for difficulty in difficulties}
# with open('data/NL2SQL/SynSQL-2.5M/data_filtered.json', 'r') as infile:
#     data = json.load(infile)
#     for item in data:
#         if 'sql_complexity' in item and 'db_id' in item:
#             complexity = item['sql_complexity']
#             if complexity in difficulties:
#                 db_id_counts[complexity].add(item['db_id'])

# # 输出每个难度的 db_id 种类数量
# for difficulty in difficulties:
#     unique_db_id_count = len(db_id_counts[difficulty])
#     print(f"{difficulty} 难度的不同 db_id 数量为 {unique_db_id_count} 种。")