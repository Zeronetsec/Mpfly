function install::installer() {
    if [[ ! -d "${HOME}/.mpfly" ]]; then
        install::getinstall \
            "command mkdir -p ${HOME}/.mpfly" \
            "Create directory: ${color_GG}${HOME}/.mpfly${color_N}"
    fi

    if [[ ! -d "${HOME}/.config/mpv" ]]; then
        install::getinstall \
            "command mkdir -p ${HOME}/.config/mpv" \
            "Create directory: ${color_GG}${HOME}/.config/mpv${color_N}"
    fi
}; readonly -f install::installer