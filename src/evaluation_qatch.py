from qatch.connectors.sqlite_connector import SqliteConnector
from qatch.evaluate_dataset.orchestrator_evaluator import OrchestratorEvaluator

# init orchestrator evaluator 
evaluator = OrchestratorEvaluator()

connector = SqliteConnector(
    relative_db_path='<your_sqlite_path>',
    db_name='<your_db_name>',
)

# solution with df:
# Returns: The input dataframe enriched with the metrics computed for each test case.
evaluator.evaluate_df(
    df='<the pandas df>',
    target_col_name='<target_column_name>',
    prediction_col_name='<prediction_column_name>',
    db_path_name='<db_path_column_name>'
)