import torch
import onnx
from impoved_dqn_agent import ImprovedDQN

model = ImprovedDQN()
model.eval()

dummy_input = torch.randn(1, 119+17*4+20+3)
model.load_state_dict(torch.load('./best_models/harmless/dqn_model.pth', map_location='cpu'))

torch.onnx.export(
    model,
    dummy_input,
    "harmless.onnx",
    export_params=True,
    opset_version=11,
    do_constant_folding=True,
    input_names=['input'],
    output_names=['output'],
    dynamic_axes={'input': {0: 'batch_size'}, 'output': {0: 'batch_size'}}
)

print("Model exported to dqn_model.onnx")

