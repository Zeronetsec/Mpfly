function install::extern::privdat() {
    local i

    if [[ -d "${root}/.privdat" ]]; then
        echo -e "${B}[*] ${N}Setting up private data..."
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
                "Replace: ${GG}${root}/.privdat/mpv/${i} ${DG}-> ${GG}${HOME}/.config/mpv/${i}"
        done

        install::getinstall \
            "
                command cat \
                ${root}/.privdat/mptrack.lst \
                > ${HOME}/.mpfly/mptrack.lst
            " \
            "Replace: ${GG}${root}/.privdat/mptrack.lst ${DG}-> ${GG}${HOME}/.mpfly/mptrack.lst"
    fi
}; readonly -f install::extern::privdat