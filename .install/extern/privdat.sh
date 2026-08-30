function install::extern::privdat() {
    local i

    if [[ -d "${root}/.privdat" ]]; then
        echo -e "${color_B}[*] ${color_N}Setting up private data..."
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

        command mapfile -t mpvcfg < <(
            command ls "${root}/.privdat/mpv/" \
                --color=never \
                2>/dev/null
        )

        for i in "${mpvcfg[@]}"; do
            install::getinstall \
                "
                    command cat \
                        ${root}/.privdat/mpv/${i} \
                        > ${HOME}/.config/mpv/${i}
                " \
                "Replace: ${color_GG}${root}/.privdat/mpv/${i} ${color_DG}-> ${color_GG}${HOME}/.config/mpv/${i}${color_N}"
        done

        install::getinstall \
            "
                command cat \
                ${root}/.privdat/mptrack.lst \
                > ${HOME}/.mpfly/mptrack.lst
            " \
            "Replace: ${color_GG}${root}/.privdat/mptrack.lst ${color_DG}-> ${color_GG}${HOME}/.mpfly/mptrack.lst${color_N}"
    fi
}; readonly -f install::extern::privdat