#!/bin/bash

## Shell Opts ----------------------------------------------------------------

set -euv
set -o pipefail

## Vars ----------------------------------------------------------------------

QTEST_API_TOKEN=$RPC_ASC_QTEST_API_TOKEN
VENV_NAME="venv-qtest"
PROJECT_ID="76551"
TEST_CYCLE="CL-1"

## Functions -----------------------------------------------------------------

source $(dirname ${0})/../../scripts/functions.sh

## Main ----------------------------------------------------------------------

# Create virtualenv for <TOOL NAME>
virtualenv --no-setuptools --no-wheel "${VENV_NAME}"

# Activate virtualenv
source "${VENV_NAME}/bin/activate"

VENV_PIP="${VENV_NAME}/bin/pip"

# Install tagged development version of <TOOL NAME>
${VENV_PIP} install -e git+git://github.com/ryan-rs/py-result-uploader.git@v0.2.0#egg=py-result-uploader-0.2.0

# search for xml files in RE_HOOK_RESULTS_DIR
find $RE_HOOK_RESULTS_DIR -type f -name '*.xml' | while read -r i
do
    # Use <TOOL NAME> to process and upload to qtest
    if py_result_uploader $i $PROJECT_ID $TEST_CYCLE; then
        echo "Successfully uploaded $i"
    else
        echo "File $i failed to upload"
    fi
done
