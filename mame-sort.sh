#!/bin/bash

set -e

# Defaults
LIST_FILE=""
INPUT_DIR=""
OUTPUT_DIR=""
CLEAN_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -l|--list)
            LIST_FILE="$2"
            shift 2
            ;;
        -r|--roms)
            INPUT_DIR="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -c|--clean)
            CLEAN_MODE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate required parameters
if [[ -z "$LIST_FILE" ]]; then
    echo "Error: -l / --list parameter is required"
    exit 1
fi

if [[ -z "$INPUT_DIR" ]]; then
    echo "Error: -r / --roms parameter is required"
    exit 1
fi

if [[ -z "$OUTPUT_DIR" ]]; then
    echo "Error: -o / --output parameter is required"
    exit 1
fi

# Check list file exists and readable
if [[ ! -f "$LIST_FILE" ]]; then
    echo "Error: List file '$LIST_FILE' does not exist"
    exit 1
fi

if [[ ! -r "$LIST_FILE" ]]; then
    echo "Error: No read permission for list file '$LIST_FILE'"
    exit 1
fi

# Check input directory exists and readable
if [[ ! -d "$INPUT_DIR" ]]; then
    echo "Error: Input directory '$INPUT_DIR' does not exist"
    exit 1
fi

if [[ ! -r "$INPUT_DIR" ]]; then
    echo "Error: No read permission for input directory '$INPUT_DIR'"
    exit 1
fi

# Create output directory if not exists
if [[ ! -d "$OUTPUT_DIR" ]]; then
    mkdir -p "$OUTPUT_DIR" || {
        echo "Error: Cannot create output directory '$OUTPUT_DIR'"
        exit 1
    }
fi

# Check output directory is writable
if [[ ! -w "$OUTPUT_DIR" ]]; then
    echo "Error: No write permission for output directory '$OUTPUT_DIR'"
    exit 1
fi

# Track copied files for clean mode
COPIED_FILES=()

# Read list and copy files
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines
    [[ -z "$line" ]] && continue
    
    # Remove .zip if present, then add it back
    game_code="${line%.zip}"
    rom_file="${game_code}.zip"
    src_path="${INPUT_DIR}/${rom_file}"
    
    if [[ -f "$src_path" ]]; then
        if [[ ! -r "$src_path" ]]; then
            echo "Error: No read permission for '$src_path'"
            exit 1
        fi
        
        cp "$src_path" "$OUTPUT_DIR/" || {
            echo "Error: Failed to copy '$src_path'"
            exit 1
        }
        
        COPIED_FILES+=("$src_path")
        echo "Copied: $rom_file"
    else
        echo "Warning: File not found: $rom_file"
    fi
done < "$LIST_FILE"

# Copy list file to output directory
cp "$LIST_FILE" "$OUTPUT_DIR/" || {
    echo "Error: Failed to copy list file to output directory"
    exit 1
}
echo "Copied list file: $(basename "$LIST_FILE")"

# Clean mode: remove copied files and list file
if [[ "$CLEAN_MODE" == true ]]; then
    echo ""
    echo "Clean mode: removing source files..."
    
    # Check write permission on input directory
    if [[ ! -w "$INPUT_DIR" ]]; then
        echo "Error: No write permission for input directory '$INPUT_DIR'"
        exit 1
    fi
    
    for src_path in "${COPIED_FILES[@]}"; do
        if [[ -f "$src_path" ]]; then
            rm "$src_path" || {
                echo "Error: Failed to remove '$src_path'"
                exit 1
            }
            echo "Removed: $src_path"
        fi
    done
    
    # Remove original list file
    if [[ -f "$LIST_FILE" ]]; then
        rm "$LIST_FILE" || {
            echo "Error: Failed to remove list file '$LIST_FILE'"
            exit 1
        }
        echo "Removed list file: $LIST_FILE"
    fi
fi

echo ""
echo "Done. Processed ${#COPIED_FILES[@]} file(s)."
