#!/usr/bin/env bash

set -o errexit

src="${BASH_SOURCE[0]}"
while [[ -h "${src}" ]]; do
    dir="$(
        cd -P "$(
            command dirname "${src}"
        )" > /dev/null 2>&1 && pwd
    )"
    src="$(command readlink "${src}")"
    [[ "${src}" != /* ]] && src="${dir}/${src}"
done

dir="$(
    cd -P "$(
        command dirname "${src}"
    )" > /dev/null 2>&1 && pwd
)"

export root="${dir}"; readonly root
source "${root}/.install/include.sh"

include : '(
    .install/color
    .install/variable
    .install/error
    .install/getinstall
)'

HOME="${HOME}"
__RMBK__=false
__RMCFG__=true

while [[ ${#} -gt 0 ]]; do
    case "${1}" in
        "--home="*) export HOME="${1#*=}" ;;
        "--remove-backup") export __RMBK__=true ;;
        "--no-remove-config") export __RMCFG__=false ;;
    esac
    shift
done

if [[ "${__RMBK__}" == true ]]; then
    install::getinstall \
        "command rm -f ${opt}/${targetins}_*.zip.bak" \
        "Removing all backup..."
fi

install::getinstall \
    "command rm -rf ${opt}/${targetins}" \
    "Removing: ${GG}${opt}/${targetins}${N}"

install::getinstall \
    "command rm -f ${bin}/${targetins}" \
    "Removing: ${GG}${bin}/${targetins}${N}"

if [[ "${__RMCFG__}" == true ]]; then
    if [[ -d "${HOME}/.mpfly" ]]; then
        install::getinstall \
            "command rm -rf ${HOME}/.mpfly" \
            "Removing: ${GG}${HOME}/.mpfly${N}"
    fi
fi

echo -e "${GG}[+] ${N}${targetins^} removed!"

trap - EXIT
exit ${?}