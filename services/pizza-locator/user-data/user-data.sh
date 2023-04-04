# Global variables are defined above this line by terraform
# Everything that follows is vanilla Bash
# i.e. this is not a terrform template, os ${} does not have to be escaped

set -e  # Exit on any error
set -E  # Enable functions to inherit ERR trap so errors are properly logged
set -o functrace  # Enable tracing functions to log errors
set -u  # Exit on attempt to reference empty variable
set -o pipefail  # Exit on any pipelined failure

function log_failure {
    printf "\n❌${BASH_SOURCE} Failed at line ${1}: ${2}\n"; exit 1
}
trap 'log_failure ${LINENO} "${BASH_COMMAND}"' ERR

# Call this function on the first line of all below functions in this script
function log_this_func {
    : "${STEP_COUNTER:=-1}"  # Sets STEP_COUNTER to -1 if unset without causing unbound variable error
    STEP_COUNTER=$((STEP_COUNTER+1))
    printf "\n🔵[Step ${STEP_COUNTER}, user-data-consul.sh] line $(( ${BASH_LINENO[0]} - 1 )), ${FUNCNAME[1]}\n"
}


function initialize_pizza_vars {
    log_this_func

    do_something_here
}


initialize_pizza_vars

echo "✅user_data complete."
