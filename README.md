# 🕹️ mame-sort

Bash script to build curated MAME ROM collections from a text list.

## ⚡ Quick Start

```bash
./mame-sort.sh -l list.txt -r /path/to/roms -o /path/to/output
```

## 📋 Arguments

| Flag | Description |
|------|-------------|
| `-l`, `--list` | Text file with ROM names (one per line) |
| `-r`, `--roms` | Source directory with MAME ROMs |
| `-o`, `--output` | Target directory (created if missing) |
| `-c`, `--clean` | ⚠️ Delete originals after copying |

## 📝 List Format

```
kof98
garou.zip
dino
```

One ROM per line. `.zip` extension is optional.

## 📦 Install

```bash
curl -L https://raw.githubusercontent.com/izmaelmag/mame-sort.sh/main/mame-sort.sh -o mame-sort.sh
chmod +x mame-sort.sh
```

## 💡 Examples

Copy ROMs:

```bash
./mame-sort.sh \
  --list ./lists/shmups.txt \
  --roms ./roms \
  --output ./collections/shmups
```

Copy and remove originals:

```bash
./mame-sort.sh \
  --list ./lists/favorites.txt \
  --roms ./roms \
  --output ./collections/favorites \
  --clean
```
