# androidBruter.sh

A script for brute-forcing Android device PIN codes using the ADB (Android Debug Bridge) tool.

## Overview

This script allows you to perform a brute force attack on Android device PIN codes. It utilizes the `adb` command-line tool to verify the validity of PIN codes. The script supports both sequential and parallel processing for faster brute force attacks.

## Usage

```shell
./androidBruter.sh -l <pin_length> -n <num_processes> -s <start_pin> -e <end_pin> [-f <password_file>]
```

### Options

- `-l, --pin-length LENGTH`: Length of the PIN code (between 4 and 12).
- `-n, --num-processes PROCESSES`: Number of parallel processes to use (default: 1, max: 9).
- `-s, --start-pin PIN`: Starting PIN code (default: 0).
- `-e, --end-pin PIN`: Ending PIN code (default: 9999).
- `-f, --file PASSWORD_FILE`: File containing passwords to verify.
- `-h, --help`: Display the help message.

## Grid Structure

The script operates on a 3x3 grid representing the PIN code possibilities:

```
 1 | 2 | 3 
---+---+---
 4 | 5 | 6 
---+---+---
 7 | 8 | 9 
```

## Examples

1. Brute force attack on a 4-digit PIN code range (0000 to 9999) using 4 parallel processes:
   ```shell
   ./androidBruter.sh -l 4 -n 4
   ```

2. Brute force attack on a specific range (1000 to 2000) using a password file:
   ```shell
   ./androidBruter.sh -l 4 -s 1000 -e 2000 -f passwords.txt
   ```

## Requirements

- ADB (Android Debug Bridge) tool installed on the system.
- A connected Android device with USB debugging enabled.

## Logging

The script logs the brute force attempts and results to a file named `brute_force.log`.

## License

This script is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Owner

- Owner: wuseman
- Creator: wuseman
- Website: [https://www.nr1.nu](https://www.nr1.nu)

For related projects, you can also check out the following repository:

- [https://github.com/wuseman/adb-shell/bruteforce](https://github.com/wuseman/adb-shell/bruteforce)
- GitHub Repository: [https://github.com/wuseman/WBRUTER/extra/](https://github.com/wuseman/WBRUTER/extra/)

---

Feel free to modify the script and adapt it to your specific use case. For more information, refer to the script's comments and the usage instructions provided above.

If you encounter any issues or have questions, please reach out to the owner or creator mentioned above or open an issue on the respective GitHub repository.

Enjoy brute forcing PIN codes responsibly!


