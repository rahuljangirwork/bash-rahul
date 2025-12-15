#!/bin/bash

# Define the location of the .bashrc file to test
BASHRC_FILE="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )/.bashrc"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Testing .bashrc configuration..."
echo "Sourcing $BASHRC_FILE..."

# Start a new bash session to test the configuration
bash -c "source $BASHRC_FILE && (
    echo 'Running tests within sourced environment...'
    FAILED=0

    # Helper function for assertions
    assert_alias() {
        if alias \"\$1\" >/dev/null 2>&1; then
            echo -e \"${GREEN}[PASS] Alias '\$1' is defined${NC}\"
        else
            echo -e \"${RED}[FAIL] Alias '\$1' is missing${NC}\"
            FAILED=1
        fi
    }

    assert_function() {
        if declare -f \"\$1\" >/dev/null; then
            echo -e \"${GREEN}[PASS] Function '\$1' is defined${NC}\"
        else
            echo -e \"${RED}[FAIL] Function '\$1' is missing${NC}\"
            FAILED=1
        fi
    }

    # Test Aliases
    assert_alias 'll'
    assert_alias 'la'
    assert_alias 'grep'
    assert_alias 'mv' # should be mv -i
    assert_alias 'rm' # should be trash -v

    # Test Functions
    assert_function 'extract'
    assert_function 'cpg'
    assert_function 'mvg'
    assert_function 'mkdirg'

    # Test Environment Variables
    if [ \"\$HISTSIZE\" -eq 500 ]; then
        echo -e \"${GREEN}[PASS] HISTSIZE is 500${NC}\"
    else
        echo -e \"${RED}[FAIL] HISTSIZE is \$HISTSIZE (expected 500)${NC}\"
        FAILED=1
    fi

    if [ \"\$EDITOR\" == \"nvim\" ]; then
         echo -e \"${GREEN}[PASS] EDITOR is nvim${NC}\"
    else
         echo -e \"${RED}[FAIL] EDITOR is \$EDITOR (expected nvim)${NC}\"
         FAILED=1
    fi
     
    exit \$FAILED
)"

# Capture the exit code of the subshell
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
