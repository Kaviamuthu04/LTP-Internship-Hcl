# LTP Setup and Usage Guide

This guide explains how to install, build, and run the Linux Test Project (LTP) on Ubuntu 24.04.

---

### Step 1: Update your system

Open terminal and run:
```bash
sudo apt update && sudo apt upgrade -y
```
### Step 2: Install required dependencies

Install all necessary packages:

sudo apt install -y git make automake autoconf gcc bc libcap-dev libattr1-dev libaio-dev \
libnuma-dev libtool libtool-bin m4 pkg-config python3 python3-pip bison flex gawk texinfo libdb-dev libssl-dev

### Step 3: Clone the LTP repository
git clone https://github.com/linux-test-project/ltp.git
cd ltp

### Step 4: Build and install LTP

Run the following commands one by one:

make autotools
./configure
make
sudo make install

### Step 5: Run LTP tests

To run the full default test suite:
sudo /opt/ltp/runltp

To run memory management tests only:
sudo /opt/ltp/runltp -f mm

To run file system tests only:
sudo /opt/ltp/runltp -f fs

### Step 6: Save logs for review

Create a folder for logs:
mkdir -p ~/ltp_logs

Run tests and save output to log files:
sudo /opt/ltp/runltp -f mm -o ~/ltp_logs/mem-test.log
sudo /opt/ltp/runltp -f fs -o ~/ltp_logs/fs-test.log

### Notes:
Use sudo because tests need root privileges.
The -f option specifies the test family to run.
Logs help analyze and track test results over time.

