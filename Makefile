# Variables
SCRIPT := kali-setup-arm64.sh

.PHONY: all setup lint clean

all: setup

# Run the main setup script
setup:
    bash $(SCRIPT)

# Lint the shell script with ShellCheck
lint:
    shellcheck $(SCRIPT)

# Remove caches/logs
clean:
    rm -rf .cache *.log

# Show help
help:
    @echo "Available targets:"
    @echo "  all     - alias for setup"
    @echo "  setup   - run $(SCRIPT)"
    @echo "  lint    - run shellcheck"
    @echo "  clean   - remove caches and logs"
