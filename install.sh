set -euo pipefail
set -euo pipefail

unset CONDA_PREFIX CONDA_DEFAULT_ENV CONDA_PROMPT_MODIFIER || true
unset CONDA_SHLVL || true
while IFS='=' read -r k _; do
  if [[ "$k" =~ ^CONDA_PREFIX_[0-9]+$ ]]; then
    unset "$k"
  fi
done < <(env)

for d in \
  "/usr/share/miniconda/bin" \
  "/usr/local/miniconda/bin" \
  "/opt/conda/bin" \
  "$HOME/miniconda/bin" \
  "$HOME/miniconda3/bin" \
  "$HOME/mambaforge/bin" \
  "$HOME/miniforge3/bin" \
  "$HOME/anaconda3/bin" \
  "$HOME/.local/share/mamba/condabin" \
; do
  if [ -d "$d" ]; then
    case ":$PATH:" in
      *":$d:"*) : ;;
      *) export PATH="$d:$PATH" ;;
    esac
  fi
done

CONDA_BIN="$(command -v conda || true)"
CONDA_SH=""

if [ -n "${CONDA_BIN}" ] && [ -x "${CONDA_BIN}" ]; then
  CONDA_BASE="$(cd "$(dirname "$(dirname "${CONDA_BIN}")")" && pwd)"
  if [ -f "${CONDA_BASE}/etc/profile.d/conda.sh" ]; then
    CONDA_SH="${CONDA_BASE}/etc/profile.d/conda.sh"
  fi
fi

if [ -z "${CONDA_SH}" ] && [ -n "${CONDA_EXE:-}" ] && [ -x "${CONDA_EXE}" ]; then
  CONDA_BASE="$(cd "$(dirname "$(dirname "${CONDA_EXE}")")" && pwd)"
  if [ -f "${CONDA_BASE}/etc/profile.d/conda.sh" ]; then
    CONDA_SH="${CONDA_BASE}/etc/profile.d/conda.sh"
  fi
fi

if [ -z "${CONDA_SH}" ]; then
  for b in \
    "${CONDA_PREFIX:-}" \
    "${CONDA:-}" \
    "${MAMBA_ROOT_PREFIX:-}" \
    "/usr/share/miniconda" \
    "/opt/conda" \
    "$HOME/miniconda" \
    "$HOME/miniconda3" \
    "$HOME/mambaforge" \
    "$HOME/miniforge3" \
    "$HOME/anaconda3" \
  ; do
    if [ -n "$b" ] && [ -f "$b/etc/profile.d/conda.sh" ]; then
      CONDA_SH="$b/etc/profile.d/conda.sh"
      break
    fi
  done
fi

if [ -n "${CONDA_SH}" ]; then
  source "${CONDA_SH}" || true
fi

CONDA_BIN="$(command -v conda || true)"
if [ -z "${CONDA_BIN}" ]; then
  echo "ERROR: conda not found" >&2
  echo "PATH=$PATH" >&2
  exit 127
fi
command -v conda >/dev/null 2>&1 || { echo "ERROR: conda not available after bootstrap" >&2; exit 127; }
unset CONDA_PREFIX CONDA_DEFAULT_ENV CONDA_PROMPT_MODIFIER || true
unset CONDA_SHLVL || true
while IFS='=' read -r k _; do
  if [[ "$k" =~ ^CONDA_PREFIX_[0-9]+$ ]]; then
    unset "$k"
  fi
done < <(env)
export CONDA_NO_PLUGINS=true
conda activate "eos80k1"
conda install -c pytorch pytorch=2.5.1 -y
conda install -c conda-forge pandas=1.5.3 -y
conda install -c conda-forge scikit-learn=1.4.2 -y
/home/marina/anaconda3/envs/eos80k1/bin/python -m pip install rdkit==2024.3.5
/home/marina/anaconda3/envs/eos80k1/bin/python -m pip install numpy==1.24.4