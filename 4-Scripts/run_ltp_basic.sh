# 📂 scripts/ - LTP Automation Scripts

This folder is intended for useful automation scripts related to Linux Test Project (LTP) usage and log handling.

---

## ✅ Task for you

As part of continuing the internship work, you are expected to:
1. Understand how the `runltp` command works.
2. Write small shell scripts to simplify the process of running tests and managing logs.
3. Document your script with clear comments.

### 🔧 Example Script (Provided)

File: `run_ltp_basic.sh`

```bash
#!/bin/bash
# run_ltp_basic.sh - Basic automation to run LTP tests and save logs

# Create logs folder if not exists
mkdir -p ~/ltp_logs

# Run Memory Test
echo "Running Memory Tests..."
sudo /opt/ltp/runltp -f mm -o ~/ltp_logs/mem-test.log

# Run File System Test
echo "Running File System Tests..."
sudo /opt/ltp/runltp -f fs -o ~/ltp_logs/fs-test.log

# Success message
echo "✅ Tests completed. Logs saved in ~/ltp_logs/"

# Run it using:
chmod +x scripts/run_ltp_basic.sh
./scripts/run_ltp_basic.sh

#📌 Your Task

Add at least one useful script to automate or simplify LTP-related activities. You can pick from the ideas below:
| Script Name              | Purpose                                             |
| ------------------------ | --------------------------------------------------- |
| `cleanup_logs.sh`        | Delete or archive old logs from `~/ltp_logs/`       |
| `check_ltp_installed.sh` | Verify if LTP is installed and all binaries present |
| `auto_log_uploader.sh`   | Automatically push logs to GitHub or shared folder  |
| `run_selected.sh`        | Run a custom list of test cases                     |
| `extract_failures.sh`    | Extract failed test cases from log files            |

# Submit your script by:
    Adding it to this folder (scripts/)
    Commenting each step inside the script
    Testing it and verifying the output

# Goal
By the end of this task, you will:
    Learn shell scripting basics
    Automate common testing procedures
    Maintain a collaborative LTP testing toolkit for future use
