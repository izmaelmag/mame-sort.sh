# mame-sort

`mame-sort.sh` is a small Bash script for macOS/Linux that builds curated sets of MAME ROMs from a plain text list. It is useful for creating thematic collections or playlists for RetroArch and other frontends. [code_file:0]

## Features

- Reads a text file with MAME ROM codes (one per line, with or without .zip).
- Searches for the corresponding archives in a source ROM directory.
- Copies all found ROMs into a target directory.
- Copies the original list file into the target directory as a reference.
- Optional `--clean` mode removes the original ROMs and the list file after copying.
- Validates arguments, checks file/directory existence and permissions, and exits with clear error messages.

## Requirements

- Bash (macOS or Linux).
- Read access to the list file and input directory, write access to the output directory.

## Installation

```bash
git clone https://github.com/izmaelmag/mame-sort.sh.git
cd mame-sort.sh
chmod +x mame-sort.sh
```

## Usage

Basic invocation:

```bash
./mame-sort.sh -l gameslist-1.txt -i ./roms -o ./games-1
```

### Arguments

- `--list <file>` (shortcut `-l`)
  Path to the text file containing ROM codes, one per line. **Required**.

- `--input <dir>` (shortcut `-i`)
  Directory that contains the source MAME ROM archives (*.zip). **Required**.

- `--output <dir>` (shortcut `-o`)
  Directory where selected ROMs and the list file will be copied. Required.
  > If it does not exist, it will be created automatically. 

- `--clean` or `-c`
  Optional flag. If present, the script deletes the original ROMs found in `--input` and the original list file after successful copying.

All options except `-c` or `--clean` are mandatory; unknown options cause the script to exit with an error.

### Examples

Create a collection without touching the original ROMs:

```bash
./mame-sorter.sh \
  --list ./lists/shmups.txt \
  --input ./roms/mame \
  --output ./collections/shmups
```

Create a collection and remove the originals (dangerous — use with care):

```bash
./mame-sorter.sh \
  -l ./lists/favorites.txt \
  -i ./roms/mame \
  -o ./collections/favorites \
  -c
```

## List file format

The list file is a plain text file, for example:

```txt
kof98.zip
garou
dino.zip
```

Rules:

- One ROM code per line.
- Lines may have .zip or not; the script normalizes them to `<code>.zip`.
- Empty lines are ignored.
