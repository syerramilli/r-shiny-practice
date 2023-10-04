#!/bin/bash

# assumes python 3.9 is installed in your system
python3.9 -m venv gp_app
source gp_app/bin/activate # Mac/Linux
pip install numpy scipy tensorflow gpflow

python -m ipykernel install --user --name=gp_app # to enable venv to be used inside jupyter
