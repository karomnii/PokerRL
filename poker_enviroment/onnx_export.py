import torch
from dqn_agent import DQN

model = DQN()
model.eval()

dummy_input = torch.randn(1, 119)
model.load_state_dict(torch.load('./models/2025-04-22_23-51-42-711/dqn_model.pth'))

torch.onnx.export(
    model,
    dummy_input,
    "dqn_model.onnx",
    export_params=True,
    opset_version=11,
    do_constant_folding=True,
    input_names=['input'],
    output_names=['output'],
    dynamic_axes={'input': {0: 'batch_size'}, 'output': {0: 'batch_size'}}
)

print("Model exported to dqn_model.onnx")

