import os
import sys

# add code directory to path so the local `src` package is importable
root = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, root)

import csv  
import json  

import numpy as np  
import torch  
from rdkit import Chem  
from rdkit.Chem import AllChem, rdFingerprintGenerator
from src.model_training_functions import NeuralNetworkModel  

# parse arguments
input_file = sys.argv[1]
output_file = sys.argv[2]

# load model params and weights from checkpoints
checkpoints_dir = os.path.join(root, "..", "..", "checkpoints")
model_path = os.path.join(checkpoints_dir, "BSI_Large.pth")
params_path = os.path.join(checkpoints_dir, "BSI_Large.params.json")

with open(params_path) as f:
    params = json.load(f)

hidden_layers = params["hidden_layers"]
dropout = float(params["dropout"])
fp_bits = int(params["fp_bits"])

_model = NeuralNetworkModel(
    hidden_layers=hidden_layers,
    dropout_prob=dropout,
    input_size=fp_bits,
    output_size=1,
)
state = torch.load(model_path, map_location="cpu", weights_only=True)
_model.load_state_dict(state)
_model.eval()

# embedding extractor: all layers except the final Linear(64->1) + Sigmoid
_encoder = _model.model[:-2]
EMBEDDING_DIM = hidden_layers[-1]  # 64
_morgan_gen = rdFingerprintGenerator.GetMorganGenerator(radius=2, fpSize=fp_bits)


# my model: takes a list of SMILES and returns BSI network embeddings (64-dim each)
def my_model(smiles_list):
    results = []
    with torch.no_grad():
        for smi in smiles_list:
            mol = Chem.MolFromSmiles(smi)
            if mol is None:
                results.append([float("nan")] * EMBEDDING_DIM)
                continue
            fp = _morgan_gen.GetFingerprintAsNumPy(mol)
            arr = np.array(fp, dtype=np.float32)
            x = torch.from_numpy(arr).unsqueeze(0)  # (1, fp_bits)
            emb = _encoder(x).squeeze(0).numpy()    # (EMBEDDING_DIM,)
            results.append(emb.tolist())
    return results


# read SMILES from .csv file, assuming one column with header
with open(input_file, "r") as f:
    reader = csv.reader(f)
    next(reader)  # skip header
    smiles_list = [r[0] for r in reader]

# run model
outputs = my_model(smiles_list)

# check input and output have the same length
input_len = len(smiles_list)
output_len = len(outputs)
assert input_len == output_len

# write output in a .csv file
with open(output_file, "w") as f:
    writer = csv.writer(f)
    writer.writerow([f"bsi_dim_{i:02d}" for i in range(EMBEDDING_DIM)])  # header
    for row in outputs:
        writer.writerow(["" if np.isnan(float(v)) else v for v in row])
