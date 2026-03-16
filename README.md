# Bioactivity Similarity Index

The Bioactivity Similarity Index (BSI) is a machine learning model designed to identify functionally equivalent molecules that traditional structural similarity metrics often miss. While standard tools like the Tanimoto Coefficient (TC) fail to recognize approximately 60% of similarly bioactive ligand pairs due to low structural overlap ($TC < 0.30$), BSI estimates the probability that two molecules bind to the same or related protein receptors regardless of their chemical scaffold.

This model was incorporated on 2026-03-03.


## Information
### Identifiers
- **Ersilia Identifier:** `eos80k1`
- **Slug:** `bioactivity-similarity-index`

### Domain
- **Task:** `Representation`
- **Subtask:** `Featurization`
- **Biomedical Area:** `Any`
- **Target Organism:** `Any`
- **Tags:** `Embedding`, `Descriptor`

### Input
- **Input:** `Compound`
- **Input Dimension:** `1`

### Output
- **Output Dimension:** `64`
- **Output Consistency:** `Fixed`
- **Interpretation:** The output of this template model should be interpreted like this.

Below are the **Output Columns** of the model:
| Name | Type | Direction | Description |
|------|------|-----------|-------------|
| bsi_dim_00 | float |  | BSI network embedding dimension 0 |
| bsi_dim_01 | float |  | BSI network embedding dimension 1 |
| bsi_dim_02 | float |  | BSI network embedding dimension 2 |
| bsi_dim_03 | float |  | BSI network embedding dimension 3 |
| bsi_dim_04 | float |  | BSI network embedding dimension 4 |
| bsi_dim_05 | float |  | BSI network embedding dimension 5 |
| bsi_dim_06 | float |  | BSI network embedding dimension 6 |
| bsi_dim_07 | float |  | BSI network embedding dimension 7 |
| bsi_dim_08 | float |  | BSI network embedding dimension 8 |
| bsi_dim_09 | float |  | BSI network embedding dimension 9 |

_10 of 64 columns are shown_
### Source and Deployment
- **Source:** `Local`
- **Source Type:** `External`
- **S3 Storage**: [https://ersilia-models-zipped.s3.eu-central-1.amazonaws.com/eos80k1.zip](https://ersilia-models-zipped.s3.eu-central-1.amazonaws.com/eos80k1.zip)

### Resource Consumption
- **Model Size (Mb):** `3`
- **Environment Size (Mb):** `1664`


### References
- **Source Code**: [https://github.com/gschottlender/bioactivity-similarity-index](https://github.com/gschottlender/bioactivity-similarity-index)
- **Publication**: [https://www.frontiersin.org/journals/bioinformatics/articles/10.3389/fbinf.2025.1695353/full](https://www.frontiersin.org/journals/bioinformatics/articles/10.3389/fbinf.2025.1695353/full)
- **Publication Type:** `Peer reviewed`
- **Publication Year:** `2025`
- **Ersilia Contributor:** [Marina18](https://github.com/Marina18)

### License
This package is licensed under a [GPL-3.0](https://github.com/ersilia-os/ersilia/blob/master/LICENSE) license. The model contained within this package is licensed under a [MIT](LICENSE) license.

**Notice**: Ersilia grants access to models _as is_, directly from the original authors, please refer to the original code repository and/or publication if you use the model in your research.


## Use
To use this model locally, you need to have the [Ersilia CLI](https://github.com/ersilia-os/ersilia) installed.
The model can be **fetched** using the following command:
```bash
# fetch model from the Ersilia Model Hub
ersilia fetch eos80k1
```
Then, you can **serve**, **run** and **close** the model as follows:
```bash
# serve the model
ersilia serve eos80k1
# generate an example file
ersilia example -n 3 -f my_input.csv
# run the model
ersilia run -i my_input.csv -o my_output.csv
# close the model
ersilia close
```

## About Ersilia
The [Ersilia Open Source Initiative](https://ersilia.io) is a tech non-profit organization fueling sustainable research in the Global South.
Please [cite](https://github.com/ersilia-os/ersilia/blob/master/CITATION.cff) the Ersilia Model Hub if you've found this model to be useful. Always [let us know](https://github.com/ersilia-os/ersilia/issues) if you experience any issues while trying to run it.
If you want to contribute to our mission, consider [donating](https://www.ersilia.io/donate) to Ersilia!
