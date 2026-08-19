# Investigation of Selectivity with Local Frustration at Atomic Resolution

Bu repo, Chen et al. 2020 (*Surveying biomolecular frustration at atomic resolution*,
Nat Commun 11:5944) makalesinin COX-1/COX-2 selektivite bulgusunu (Figure 6, "Ligand
binding specificity correlates with minimal frustration" bölümü) `atomfrust`
pipeline'ı ile bağımsız olarak replike etmeyi amaçlar.

## Arka plan

Makale, 54 COX inhibitörünü (35 COX-2-selektif, 19 non-selektif) hem COX-1 hem
COX-2 yapısına dock edip, minimal frustre kontak sayısındaki farkın (COX-2 − COX-1)
selektiviteyle ilişkili olduğunu gösteriyor (selektif ilaçlarda ortalama +3.5,
non-selektiflerde ~0).

## Referans reseptör yapıları

| Enzim | PDB ID | Organizma | Çözünürlük | Not |
|---|---|---|---|---|
| COX-1 | 1CQE | *Ovis aries* (koyun) | 3.10 Å | Flurbiprofen bağlı (docking için çıkarılacak), HEM kofaktörü korunuyor |
| COX-2 | 1CX2 | *Mus musculus* (fare) | 2.5–3.0 Å | SC-558 bağlı (docking için çıkarılacak), HEM kofaktörü korunuyor |

Tür karışıklığı (koyun COX-1 + fare COX-2), COX docking literatüründe onlarca yıldır
kullanılan bir standart kombinasyondur (bkz. Picot et al. 1994, Kurumbail et al. 1996);
aktif site rezidüleri türler arası yüksek oranda korunmuştur.

## Klasör yapısı

```
data/
  raw_structures/       # RCSB'den indirilen ham PDB dosyaları (1CQE.pdb, 1CX2.pdb)
  ligands/               # 54 inhibitörün SMILES/mol2/pdbqt dosyaları
  prepared_receptors/    # Temizlenmiş, ligandı çıkarılmış, PDBQT'ye çevrilmiş reseptörler
docking/
  autodock/              # AutoDock4 konfigürasyon dosyaları ve çıktıları
scripts/                 # Hazırlık, docking, analiz scriptleri
results/                 # Frustrasyon analizi sonuçları, tablolar, grafikler
```

## İş akışı

1. Referans yapıları indir ve temizle (ligand/su/glikan çıkar, HEM koru)
2. AutoDock4 için reseptör hazırlığı (prepare_receptor4.py)
3. 54 ligandı hazırla (SMILES → 3D → PDBQT)
4. Her ligandı hem 1CQE hem 1CX2'ye dock et (2000 pose, en düşük skorlu pose seçilir)
5. En iyi pose'ları `atomfrust` pipeline'ına verip frustrasyon analizi çalıştır
6. Minimal frustre kontak sayısını (COX-2 − COX-1) hesapla, selektivite ile karşılaştır
