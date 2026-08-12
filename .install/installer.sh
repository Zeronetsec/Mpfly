function install::installer() {
    if [[ ! -d "${HOME}/.mpfly" ]]; then
        install::getinstall \
            "command mkdir -p ${HOME}/.mpfly" \
            "Create directory: ${GG}${HOME}/.mpfly${N}"
    fi

    if [[ ! -d "${HOME}/.config/mpv" ]]; then
        install::getinstall \
            "command mkdir -p ${HOME}/.config/mpv" \
            "Create directory: ${GG}${HOME}/.config/mpv${N}"
    fi
}; readonly -f install::installer