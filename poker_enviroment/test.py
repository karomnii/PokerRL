from training_stage_helper.encoded_card_evaluator import  EncodedCardEvaluator
from training_stage_helper.preflop_chart_evaluator import PreflopChartEvaluator

ece = EncodedCardEvaluator()
pce = PreflopChartEvaluator()
pce.display_chart("training_stage_helper/DQN_preflop_chart.json")
pce.load_chart_from_file("training_stage_helper/DQN_preflop_chart.json")
print(pce.evaluate(51,52))