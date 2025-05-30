# runltp vs kirk - LTP Execution Methods

In Linux Test Project (LTP), there are two major ways to run test suites:

---

## 🟢 1. `runltp` (What I used)

### ✅ About:
- `runltp` is the **traditional and stable** method to execute LTP test cases.
- It runs test cases based on test suite files (like `mm`, `fs`, etc.).
- Very easy to use, with simple command-line options.

### ✅ Why I used it:
- It is **well-documented**, **sufficient for baseline testing**, and easier for interns and beginners.
- Helps to **quickly validate** memory, I/O, file system performance.
- Fully compatible with Ubuntu 24.04 without additional config.

### ✅ Sample usage:
sudo /opt/ltp/runltp -f mm -o ~/ltp_logs/mem-test.log

### 2. kirk (New Framework - Not Used)
Note: I did not use kirk during this internship, but I am including this section for awareness.

🔍 About:
    kirk is the modern test runner in development to replace runltp.
    Uses YAML-based test definitions.
    Supports better test result parsing and automation.

⚠️ Why not used:
    kirk is still evolving.
    It requires Python dependencies and custom setup steps.
    Focus of this internship was on analyzing baseline performance, so runltp was sufficient.

### Summary
| Feature              | runltp (Used)   | kirk (Not Used)  |
| -------------------- | --------------- | ---------------- |
| Stability            | ✅ Stable        | ⚠️ Experimental  |
| Easy to run          | ✅ Yes           | ❌ Requires setup |
| Suitable for interns | ✅ Highly        | ❌ Advanced users |
| Output format        | Plain Text logs | JSON/YAML-based  |

### Conclusion
This project focused on runltp to validate memory and file system performance.
For future exploration or advanced automation, juniors may optionally explore kirk