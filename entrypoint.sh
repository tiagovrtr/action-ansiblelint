#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ find . -type f | grep -e "**\.yml" ] ; then
  export ANSIBLE_FILE='**.yml'
elif [ find . -type f | grep -e "**\.yaml" ] ; then
  export ANSIBLE_FILE='**.yaml'
fi

ansible-lint -p ${INPUT_ANSIBLELINT_FLAGS:-ANSIBLE_FILE} \
  | reviewdog -efm="%f:%l:%c: %m" \
      -name="ansible-lint" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}

