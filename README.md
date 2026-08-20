# Investigation of Selectivity with Local Frustration at Atomic Resolution

This repository aims to independently replicate the COX-1/COX-2 selectivity finding
reported by Chen et al. 2020 (*Surveying biomolecular frustration at atomic resolution*,
Nat Commun 11:5944), specifically Figure 6 and the "Ligand binding specificity correlates
with minimal frustration" section, using the `atomfrust` pipeline.

## Background

The study docked 54 COX inhibitors (35 COX-2-selective and 19 non-selective) into both
COX-1 and COX-2 structures and showed that the difference in the number of minimally
frustrated contacts (COX-2 − COX-1) was associated with selectivity (an average of +3.5
for selective drugs and approximately 0 for non-selective drugs).

## Reference receptor structures

| Enzyme | PDB ID | Organism | Resolution | Note |
|---|---|---|---|---|
| COX-1 | 1CQE | *Ovis aries* (sheep) | 3.10 Å | Bound to flurbiprofen (to be removed for docking); the HEM cofactor is retained |
| COX-2 | 1CX2 | *Mus musculus* (mouse) | 2.5–3.0 Å | Bound to SC-558 (to be removed for docking); the HEM cofactor is retained |

The use of structures from different species (sheep COX-1 + mouse COX-2) is a standard
combination that has been used in the COX docking literature for decades (see Picot et al.
1994 and Kurumbail et al. 1996); active-site residues are highly conserved across species.

## Directory structure
data/
raw_structures/ # Raw PDB files downloaded from the RCSB PDB (1CQE.pdb, 1CX2.pdb)
ligands/ # SMILES/mol2/pdbqt files for the 54 inhibitors
prepared_receptors/ # Cleaned, ligand-removed receptors converted to PDBQT format
docking/
autodock/ # AutoDock4 configuration files and outputs
scripts/ # Preparation, docking, and analysis scripts
results/ # Frustration analysis results, tables, and figures

## Workflow

1. Download and clean the reference structures (remove ligands/water/glycans, retain HEM)
2. Prepare the receptors for AutoDock4 (`prepare_receptor4.py`)
3. Prepare the 54 ligands (SMILES → 3D → PDBQT)
4. Dock each ligand into both 1CQE and 1CX2 (2,000 poses; select the lowest-scoring pose)
5. Submit the best poses to the `atomfrust` pipeline and run the frustration analysis
6. Calculate the number of minimally frustrated contacts (COX-2 − COX-1) and compare
   the difference with selectivity
