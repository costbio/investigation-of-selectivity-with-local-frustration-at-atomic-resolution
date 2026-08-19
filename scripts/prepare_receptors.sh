#!/usr/bin/env bash
# COX-1 (1CQE) ve COX-2 (1CX2) reseptörlerini AutoDock4 için PDBQT'ye çevirir.
#
# Gereksinimler (kendi makinenizde / frustrato conda ortamında kurun):
#   pip install meeko rdkit gemmi
#
# NOT 1: meeko'nun otomatik CCD şablon üretici modülü, HEM gibi metal içeren
# kalıntıların formal yük alanını (bazı CIF girdilerinde '?' olarak
# işaretlenmiş) sayıya çeviremediği için hata veriyor. Bu yüzden HEM'i
# yalnızca docking reseptörü için (AutoDock4 grid'i) çıkarıyoruz -- NSAID
# tipi ligandların bağlandığı siklooksijenaz kanalı (Arg120/Tyr355/Tyr385/
# Trp387/Ser530 çevresi), HEM'in oturduğu peroksidaz cebinden (His207/
# His388 çevresi) ayrı bir bölge olduğu için bu, docking sonucunu etkilemez.
#
# NOT 2: -a/--allow_bad_res bayrağı, kristal yapıda yan zincir atomları eksik
# olan yüzey rezidülerini (1CQE'de Pro32, Arg79, Lys186, Lys215, Lys248,
# Arg396 -- REMARK 470'te belgelenmiş, aktif site DIŞINDA) meeko'nun
# görmezden gelmesini sağlar.
#
# HEM'li orijinal temiz PDB dosyaları (data/prepared_receptors/*_chainA_clean.pdb)
# sonraki Rosetta frustrasyon analizi için olduğu gibi korunuyor.
#
# Kullanım:
#   bash scripts/prepare_receptors.sh

set -euo pipefail

RAW_DIR="data/prepared_receptors"
OUT_DIR="data/prepared_receptors"

for name in 1CQE 1CX2; do
    infile="${RAW_DIR}/${name}_chainA_clean.pdb"
    docking_infile="${RAW_DIR}/${name}_chainA_noHEM.pdb"
    outbase="${OUT_DIR}/${name}_receptor"

    if [ ! -f "$infile" ]; then
        echo "HATA: $infile bulunamadı. Önce data/raw_structures/ altındaki ham PDB'leri temizleyin."
        exit 1
    fi

    echo "== ${name}: HEM'siz docking kopyası oluşturuluyor =="
    grep -v "HEM" "$infile" > "$docking_infile"

    echo "== ${name} reseptörü hazırlanıyor (AutoDock4 / PDBQT) =="
    mk_prepare_receptor.py \
        -a \
        --read_pdb "$docking_infile" \
        -o "$outbase" \
        -p \
        -j \
        --write_pdb "${outbase}_prepared.pdb"

    echo "-> ${outbase}.pdbqt oluşturuldu (HEM'siz, sadece docking için)"
done

echo ""
echo "Tamamlandı. PDBQT dosyaları data/prepared_receptors/ altında."
echo "NOT: *_chainA_clean.pdb dosyaları (HEM'li) Rosetta/frustrasyon analizi için ayrıca duruyor."
