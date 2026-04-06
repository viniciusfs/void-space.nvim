#!/usr/bin/env bash
# void-space.nvim — Bash/Shell sample
# Demonstrates: variables, arrays, functions, loops, conditionals,
# arithmetic, string ops, process substitution, here-docs, traps, getopts.

set -euo pipefail
IFS=$'\n\t'

# Constants

readonly VERSION="1.0.0"
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="${TMPDIR:-/tmp}/void-space-$$.log"

# ANSI colours
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly PURPLE='\033[0;35m'
readonly RESET='\033[0m'

# Palette (associative array)

declare -A PALETTE=(
    [void]="#0d0f18"
    [nebula]="#c792ea"
    [aurora]="#89ddff"
    [comet]="#82aaff"
    [pulsar]="#ff5370"
    [quasar]="#ffcb6b"
)

# Logging

log()   { printf '%s [INFO]  %s\n'  "$(timestamp)" "$*" | tee -a "$LOG_FILE"; }
warn()  { printf '%s [WARN]  %s\n'  "$(timestamp)" "$*" | tee -a "$LOG_FILE" >&2; }
error() { printf '%s [ERROR] %s\n'  "$(timestamp)" "$*" | tee -a "$LOG_FILE" >&2; }
die()   { error "$*"; exit 1; }

timestamp() { date '+%Y-%m-%dT%H:%M:%S'; }

# Trap / cleanup

cleanup() {
    local exit_code=$?
    rm -f "$LOG_FILE"
    if [[ $exit_code -ne 0 ]]; then
        error "Script exited with code $exit_code"
    fi
}
trap cleanup EXIT
trap 'die "Interrupted"' INT TERM

# Usage

usage() {
    cat <<EOF
Usage: $SCRIPT_NAME [OPTIONS]

Void Space theme sample script.

OPTIONS:
  -h          Show this help message
  -v          Print version and exit
  -n COUNT    Number of Fibonacci numbers to print (default: 10)
  -o OUTPUT   Output file (default: stdout)

EXAMPLES:
  $SCRIPT_NAME -n 15
  $SCRIPT_NAME -o results.txt

EOF
}

# Argument parsing

FIB_COUNT=10
OUTPUT=""

while getopts ':hvn:o:' opt; do
    case "$opt" in
        h) usage; exit 0 ;;
        v) echo "$SCRIPT_NAME v$VERSION"; exit 0 ;;
        n) FIB_COUNT="$OPTARG" ;;
        o) OUTPUT="$OPTARG" ;;
        :) die "Option -$OPTARG requires an argument" ;;
        ?) die "Unknown option: -$OPTARG" ;;
    esac
done
shift $((OPTIND - 1))

# Functions

# require_cmd checks that a command exists in PATH.
require_cmd() {
    local cmd="$1"
    command -v "$cmd" &>/dev/null || die "Required command not found: $cmd"
}

# is_integer returns 0 if argument is a non-negative integer.
is_integer() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# repeat_str repeats string $1 exactly $2 times.
repeat_str() {
    local str="$1"
    local n="$2"
    local result=""
    local i
    for (( i = 0; i < n; i++ )); do
        result+="$str"
    done
    printf '%s' "$result"
}

# upper converts a string to uppercase (pure bash, no tr).
upper() {
    local str="$1"
    printf '%s' "${str^^}"
}

# fibonacci prints the first N fibonacci numbers.
fibonacci() {
    local n="$1"
    is_integer "$n" || die "fibonacci: expected integer, got '$n'"

    local a=0 b=1 tmp i
    local -a seq=()

    for (( i = 0; i < n; i++ )); do
        seq+=("$a")
        tmp=$(( a + b ))
        a=$b
        b=$tmp
    done

    printf '%s\n' "${seq[*]}"
}

# star_class maps solar mass to a spectral class letter.
star_class() {
    local mass_x10="$1"   # mass * 10 as integer to avoid floats
    if   (( mass_x10 >= 160 )); then echo "O"
    elif (( mass_x10 >= 21  )); then echo "B"
    elif (( mass_x10 >= 14  )); then echo "A"
    elif (( mass_x10 >= 10  )); then echo "F"
    elif (( mass_x10 >= 8   )); then echo "G"
    elif (( mass_x10 >= 5   )); then echo "K"
    else echo "M"
    fi
}

# print_palette prints all palette swatches.
print_palette() {
    echo -e "${PURPLE}── Palette ──────────────────────────────────────${RESET}"
    local key
    for key in "${!PALETTE[@]}"; do
        printf "  %-10s %s\n" "$key" "${PALETTE[$key]}"
    done | sort
    echo
}

# survey_stars prints a formatted table of stars.
survey_stars() {
    local -n _stars="$1"   # nameref

    printf "${CYAN}%-20s %-6s %-10s %-12s${RESET}\n" \
        "Name" "Class" "Mass(☉)" "Lum(☉)"
    repeat_str "─" 52
    echo

    local name mass_x10 lum class
    for row in "${_stars[@]}"; do
        IFS='|' read -r name mass_x10 lum <<< "$row"
        class="$(star_class "$mass_x10")"
        printf "%-20s %-6s %-10s %-12s\n" "$name" "$class" \
            "$(echo "scale=2; $mass_x10/10" | bc)" "$lum"
    done
}

# Main logic

main() {
    require_cmd bc

    log "Starting $SCRIPT_NAME v$VERSION"

    echo -e "${GREEN}void-space v${VERSION}${RESET}"
    echo

    # Palette
    print_palette

    # Stars table (name|mass*10|luminosity)
    declare -a STARS=(
        "Sirius|21|25.4"
        "Betelgeuse|200|100000"
        "Proxima Centauri|1|0.0017"
        "Sol|10|1.0"
        "Rigel|170|120000"
    )

    echo -e "${PURPLE}── Star Catalogue ───────────────────────────────${RESET}"
    survey_stars STARS
    echo

    # Fibonacci
    echo -e "${PURPLE}── Fibonacci(${FIB_COUNT}) ──────────────────────────────────${RESET}"
    fibonacci "$FIB_COUNT"
    echo

    # Arithmetic & string ops
    local pi_approx="3.14159265"
    local radius=7
    local area
    area="$(echo "scale=4; $pi_approx * $radius ^ 2" | bc)"
    echo "Circle area (r=$radius): $area"

    local greeting="hello, void space"
    echo "Upper: $(upper "$greeting")"
    echo "Length: ${#greeting}"
    echo "Slice [0:5]: ${greeting:0:5}"
    echo "Replace: ${greeting/void/deep}"
    echo

    # Process substitution
    echo -e "${PURPLE}── Sorted palette keys ──────────────────────────${RESET}"
    while IFS= read -r line; do
        echo "  $line"
    done < <(printf '%s\n' "${!PALETTE[@]}" | sort)
    echo

    # Here-doc
    log "Writing config snippet"
    cat <<'HEREDOC'
-- Sample Neovim config
require('void-space').setup({
    transparent = false,
    italic_comments = true,
    italic_keywords = false,
})
vim.cmd('colorscheme void-space')
HEREDOC

    # Conditional / case
    local platform
    platform="$(uname -s)"
    case "$platform" in
        Linux)   echo "Running on Linux" ;;
        Darwin)  echo "Running on macOS" ;;
        MINGW*)  echo "Running on Windows (Git Bash)" ;;
        *)       warn "Unknown platform: $platform" ;;
    esac

    # Output redirect
    if [[ -n "$OUTPUT" ]]; then
        {
            echo "Generated by $SCRIPT_NAME v$VERSION"
            echo "Timestamp: $(timestamp)"
            fibonacci "$FIB_COUNT"
        } > "$OUTPUT"
        log "Results written to $OUTPUT"
    fi

    log "Done."
}

# Entry point

main "$@"
