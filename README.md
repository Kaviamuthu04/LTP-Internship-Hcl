# 🧪 Linux Test Project (LTP) - HCL Internship

Complete installation and usage guide for the Linux Test Project on Ubuntu 24.04. This repository documents my work with LTP during my HCL Technologies internship.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running Tests](#running-tests)
- [Logging and Results](#logging-and-results)
- [Result Analysis](#result-analysis)
- [Modern Kirk Runner](#modern-kirk-runner)
- [Troubleshooting](#troubleshooting)
- [Quick Reference](#quick-reference)

## 📋 Prerequisites

- Ubuntu 24.04 LTS or compatible Linux distribution
- Minimum 4GB RAM
- At least 2GB free disk space
- Root/sudo access
- Internet connection for package downloads

## 📥 Installation

### Step 1: System Update
```bash
sudo apt update && sudo apt upgrade -y
```

### Step 2: Install All Required Dependencies
```bash
sudo apt install -y git make automake autoconf gcc bc libcap-dev libattr1-dev \
libaio-dev libnuma-dev libtool libtool-bin m4 pkg-config bison flex gawk \
texinfo libdb-dev libssl-dev build-essential autotools-dev libc6-dev \
linux-libc-dev pkg-config zlib1g-dev libacl1-dev libkeyutils-dev \
libselinux1-dev libsepol1-dev keyutils libtirpc-dev
```

### Step 3: Create Working Directory
```bash
mkdir -p ~/ltp-project
cd ~/ltp-project
```

### Step 4: Clone LTP Repository
```bash
git clone --recurse-submodules https://github.com/linux-test-project/ltp.git
cd ltp
```

### Step 5: Build LTP
```bash
# Generate build scripts
make autotools

# Configure build (check system capabilities)
./configure

# Compile (this may take 10-20 minutes)
make

# Install to /opt/ltp (requires sudo)
sudo make install
```

### Step 6: Verify Installation
```bash
# Check if LTP is installed
ls -la /opt/ltp/

# Check runltp exists
which /opt/ltp/runltp
/opt/ltp/runltp --help
```

## ▶️ Running Tests

### Basic Test Execution

#### Run All Tests
```bash
sudo /opt/ltp/runltp
```

#### Run Specific Test Categories
```bash
# Memory Management Tests
sudo /opt/ltp/runltp -f mm

# File System Tests
sudo /opt/ltp/runltp -f fs

# System Calls Tests
sudo /opt/ltp/runltp -f syscalls

# Kernel Tests
sudo /opt/ltp/runltp -f kernel

# Network Tests
sudo /opt/ltp/runltp -f net

# Math Tests
sudo /opt/ltp/runltp -f math

# IPC Tests
sudo /opt/ltp/runltp -f ipc

# Process Tests
sudo /opt/ltp/runltp -f process

# Scheduler Tests
sudo /opt/ltp/runltp -f sched

# Signal Tests
sudo /opt/ltp/runltp -f signals
```

#### List Available Test Categories
```bash
ls /opt/ltp/runtest/
```

### Advanced Test Options

#### Time-Limited Testing
```bash
# Run tests for 1 hour (3600 seconds)
sudo /opt/ltp/runltp -t 3600

# Run tests for 30 minutes
sudo /opt/ltp/runltp -t 1800
```

#### Stress Testing
```bash
# Run tests multiple times
sudo /opt/ltp/runltp -i 5  # Run 5 iterations

# Continuous testing until failure
sudo /opt/ltp/runltp -c
```

#### Verbose and Debug Options
```bash
# Verbose output
sudo /opt/ltp/runltp -v

# Debug mode
sudo /opt/ltp/runltp -d /tmp/ltp-debug

# Quiet mode (minimal output)
sudo /opt/ltp/runltp -q
```

## 📊 Logging and Results

### Create Log Directory
```bash
mkdir -p ~/ltp_logs
mkdir -p ~/ltp_logs/$(date +%Y-%m-%d)
```

### Run Tests with Logging
```bash
# Basic logging
sudo /opt/ltp/runltp -f mm -o ~/ltp_logs/memory-tests.log

# Timestamped logs
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
sudo /opt/ltp/runltp -f fs -o ~/ltp_logs/filesystem_${TIMESTAMP}.log

# Multiple test categories with logs
sudo /opt/ltp/runltp -f mm -o ~/ltp_logs/mm_$(date +%Y%m%d_%H%M%S).log
sudo /opt/ltp/runltp -f fs -o ~/ltp_logs/fs_$(date +%Y%m%d_%H%M%S).log
sudo /opt/ltp/runltp -f syscalls -o ~/ltp_logs/syscalls_$(date +%Y%m%d_%H%M%S).log
```

### Comprehensive Test Script
Create `run-all-tests.sh`:
```bash
#!/bin/bash

# LTP Comprehensive Test Runner
LOG_DIR="$HOME/ltp_logs/$(date +%Y-%m-%d)"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create log directory
mkdir -p "$LOG_DIR"

echo "Starting LTP comprehensive tests at $(date)"
echo "Logs will be saved to: $LOG_DIR"

# Test categories to run
CATEGORIES=(
    "mm"
    "fs" 
    "syscalls"
    "kernel"
    "ipc"
    "sched"
    "math"
    "nptl"
    "pty"
    "containers"
    "filecaps"
    "cap_bounds"
    "fcntl-locktests"
    "connectors"
    "admin_tools"
    "timers"
    "commands"
)

# Run each category
for category in "${CATEGORIES[@]}"; do
    echo "========================================="
    echo "Running $category tests at $(date)"
    echo "========================================="
    
    log_file="$LOG_DIR/${category}_${TIMESTAMP}.log"
    
    if sudo /opt/ltp/runltp -f "$category" -o "$log_file" 2>&1; then
        echo "✅ $category tests completed"
        # Quick summary
        passed=$(grep -c "TPASS" "$log_file" 2>/dev/null || echo "0")
        failed=$(grep -c "TFAIL" "$log_file" 2>/dev/null || echo "0")
        echo "   Passed: $passed, Failed: $failed"
    else
        echo "❌ $category tests encountered errors"
    fi
    echo ""
done

echo "========================================="
echo "All tests completed at $(date)"
echo "Check detailed logs in: $LOG_DIR"
echo "========================================="

# Generate summary
echo "Generating test summary..."
total_passed=0
total_failed=0

for log in "$LOG_DIR"/*.log; do
    if [ -f "$log" ]; then
        passed=$(grep -c "TPASS" "$log" 2>/dev/null || echo "0")
        failed=$(grep -c "TFAIL" "$log" 2>/dev/null || echo "0")
        total_passed=$((total_passed + passed))
        total_failed=$((total_failed + failed))
    fi
done

echo "FINAL SUMMARY:"
echo "Total Passed: $total_passed"
echo "Total Failed: $total_failed"
echo "Total Tests: $((total_passed + total_failed))"

if [ $((total_passed + total_failed)) -gt 0 ]; then
    success_rate=$((total_passed * 100 / (total_passed + total_failed)))
    echo "Success Rate: ${success_rate}%"
fi
```

Make executable and run:
```bash
chmod +x run-all-tests.sh
./run-all-tests.sh
```

## 📈 Result Analysis

### Basic Result Checking
```bash
# Count results in a log file
LOG_FILE="~/ltp_logs/memory-tests.log"

echo "Test Results Summary:"
echo "===================="
echo "Passed: $(grep -c TPASS $LOG_FILE)"
echo "Failed: $(grep -c TFAIL $LOG_FILE)" 
echo "Skipped: $(grep -c TCONF $LOG_FILE)"
echo "Broken: $(grep -c TBROK $LOG_FILE)"
```

### Detailed Analysis Script
Create `analyze-results.sh`:
```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <log_file1> [log_file2] ..."
    exit 1
fi

for LOG_FILE in "$@"; do
    if [ ! -f "$LOG_FILE" ]; then
        echo "File not found: $LOG_FILE"
        continue
    fi
    
    echo "Analyzing: $(basename $LOG_FILE)"
    echo "================================"
    
    # Count results
    PASSED=$(grep -c "TPASS" "$LOG_FILE" 2>/dev/null || echo "0")
    FAILED=$(grep -c "TFAIL" "$LOG_FILE" 2>/dev/null || echo "0")
    SKIPPED=$(grep -c "TCONF" "$LOG_FILE" 2>/dev/null || echo "0")
    BROKEN=$(grep -c "TBROK" "$LOG_FILE" 2>/dev/null || echo "0")
    TOTAL=$((PASSED + FAILED + SKIPPED + BROKEN))
    
    echo "Total Tests: $TOTAL"
    echo "Passed: $PASSED"
    echo "Failed: $FAILED"
    echo "Skipped: $SKIPPED"
    echo "Broken: $BROKEN"
    
    if [ $TOTAL -gt 0 ]; then
        SUCCESS_RATE=$((PASSED * 100 / TOTAL))
        echo "Success Rate: ${SUCCESS_RATE}%"
    fi
    
    # Show failed tests
    if [ $FAILED -gt 0 ]; then
        echo ""
        echo "Failed Tests:"
        echo "-------------"
        grep "TFAIL" "$LOG_FILE" | head -20 | while read line; do
            test_name=$(echo "$line" | awk '{print $1}')
            echo "  ❌ $test_name"
        done
        
        if [ $FAILED -gt 20 ]; then
            echo "  ... and $((FAILED - 20)) more failures"
        fi
    fi
    
    echo ""
done
```

Make executable and use:
```bash
chmod +x analyze-results.sh

# Analyze single log
./analyze-results.sh ~/ltp_logs/memory-tests.log

# Analyze multiple logs
./analyze-results.sh ~/ltp_logs/*.log
```

## ⚙️ Modern Kirk Runner (Optional)

Kirk is the modern replacement for runltp with better features:

### Basic Kirk Usage
```bash
cd /opt/ltp

# Run syscalls with 8 parallel workers
sudo ./kirk --framework ltp --run-suite syscalls --workers 8

# Run with JSON output
sudo ./kirk --framework ltp --run-suite mm --output-format json

# Run specific test
sudo ./kirk --framework ltp --run-test mmap01

# Run with timeout
sudo ./kirk --framework ltp --run-suite fs --timeout 7200
```

### Kirk Configuration File
Create `kirk-config.yaml`:
```yaml
framework: ltp
workers: 4
timeout: 3600
output_format: json
log_level: info
suites:
  - mm
  - fs
  - syscalls
```

Run with config:
```bash
sudo ./kirk --config kirk-config.yaml
```

## 🔧 Troubleshooting

### Common Issues and Solutions

#### Permission Errors
```bash
# Always use sudo for running tests
sudo /opt/ltp/runltp -f mm

# Check LTP installation permissions
ls -la /opt/ltp/
sudo chown -R root:root /opt/ltp/
sudo chmod -R 755 /opt/ltp/
```

#### Build Failures
```bash
# Clean and rebuild
cd ~/ltp-project/ltp
make clean
make distclean
make autotools
./configure
make
sudo make install
```

#### Missing Dependencies
```bash
# Install additional development packages
sudo apt install -y libc6-dev-i386 gcc-multilib
sudo apt install -y linux-headers-$(uname -r)
```

#### Memory Issues During Build
```bash
# Limit parallel jobs
make -j2  # Instead of using all CPU cores
```

#### Test Failures Due to System Limits
```bash
# Check system limits
ulimit -a

# Increase limits temporarily
ulimit -n 65536  # Increase file descriptor limit
ulimit -u 32768  # Increase process limit

# Check kernel messages
dmesg | tail -50
```

### Debug Mode
```bash
# Run tests in debug mode
sudo /opt/ltp/runltp -f mm -v -d /tmp/ltp-debug

# Check debug output
ls -la /tmp/ltp-debug/
```

### System Information
```bash
# Check system info before testing
uname -a
cat /etc/os-release
free -h
df -h
lscpu
```

## 📋 Quick Reference

### Essential Commands
```bash
# Install LTP
sudo make install

# Run basic memory tests
sudo /opt/ltp/runltp -f mm

# Run with logging
sudo /opt/ltp/runltp -f mm -o ~/ltp_logs/test.log

# Check results
grep -c TPASS ~/ltp_logs/test.log
grep -c TFAIL ~/ltp_logs/test.log

# List test categories
ls /opt/ltp/runtest/

# Get help
/opt/ltp/runltp --help
```

### Important Paths
- **LTP Installation**: `/opt/ltp/`
- **Test Runner**: `/opt/ltp/runltp`
- **Test Categories**: `/opt/ltp/runtest/`
- **Test Binaries**: `/opt/ltp/testcases/bin/`
- **Kirk Runner**: `/opt/ltp/kirk`

### Test Result Codes
- **TPASS**: Test passed
- **TFAIL**: Test failed
- **TCONF**: Test not configured/skipped
- **TBROK**: Test broken/setup error

## 🚀 Getting Started

1. **Follow installation steps above**
2. **Run your first test:**
   ```bash
   sudo /opt/ltp/runltp -f mm -o ~/first-test.log
   ```
3. **Check results:**
   ```bash
   grep -c TPASS ~/first-test.log
   grep -c TFAIL ~/first-test.log
   ```

## 📚 Repository Contents

This repository includes:
- Complete setup documentation
- Test execution scripts
- Result analysis tools
- Sample logs and outputs
- Troubleshooting guides

## 🤝 Contributing

This project documents my LTP internship work at HCL Technologies. Feel free to:
- Report issues
- Suggest improvements
- Share your own LTP experiences

## 📄 References

- [Linux Test Project Official Repository](https://github.com/linux-test-project/ltp)
- [LTP Installation Guide](https://github.com/linux-test-project/ltp/blob/master/INSTALL)
- [Kirk Framework Documentation](https://github.com/linux-test-project/ltp/tree/master/tools/kirk)
- [LTP Test Writing Guidelines](https://github.com/linux-test-project/ltp/blob/master/doc/test-writing-guidelines.txt)

---

**Note**: Always remember to use `sudo` when running LTP tests as most require root privileges for proper kernel and system testing.

**Project Status**: Active development during HCL Technologies internship period.

**Environment**: Tested on Ubuntu 24.04 LTS with Linux kernel 6.8+
