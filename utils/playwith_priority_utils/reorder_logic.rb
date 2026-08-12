# https://github.com/Zeronetsec/Mpfly

require 'utils/color'

module PlaywithPriorityUtils
    module ReorderLogic
        def self.execute(track_name, playwith, prio)
            return playwith if playwith.nil? ||
                playwith.empty?

            track_name ||= "unknown"
            if prio.downcase == "local"
                idx = playwith.index {
                    |s| !s.start_with?(
                        "http://",
                        "https://",
                    )
                }

                if idx
                    item = playwith.delete_at(idx)
                    playwith.unshift(item)
                    printf(
                        "%s[*] %sTrack: %s%s %s-> %slocal prioritized.\n",
                        Color.B, Color.N, Color.GG, track_name, Color.DG, Color.N,
                    )
                end

                return playwith
            end

            matches = playwith.select {
                |s| s.include?(prio) &&
                    s.start_with?(
                        "http://",
                        "https://",
                    )
            }

            if matches.size == 1
                item = playwith.delete(matches.first)
                playwith.unshift(item)
                printf(
                    "%s[*] %sTrack: %s%s %s-> %s%s %sprioritized.\n",
                    Color.B, Color.N, Color.GG, track_name, Color.DG,
                    Color.GG, prio, Color.N,
                )
            elsif matches.size > 1
                printf(
                    "%s[*] %sTrack: %s%s%s\n",
                    Color.B, Color.N, Color.GG, track_name, Color.N,
                )

                printf(
                    "%s[*] %sDomain: %s%s%s\n",
                    Color.B, Color.N, Color.GG, prio, Color.N,
                )

                matches.each_with_index do |m, i|
                    branch = (i == matches.size - 1) ?
                        "└──" :
                        "├──"

                    printf(
                        "    %s%s %s%d. %s%s%s\n",
                        Color.DG, branch,
                        Color.WW, i + 1,
                        Color.GG, m, Color.N,
                    )
                end

                printf(
                    "%sHandler:\n",
                    Color.N,
                )

                printf(
                    "%s- %smpfly::return %s-> %sSelect%s\n",
                    Color.DG, Color.GG, Color.DG, Color.CC, Color.N,
                )

                printf(
                    "%s- %s<num>/<url> %s-> %sSelect%s\n",
                    Color.DG, Color.GG, Color.DG, Color.CC, Color.N,
                )

                loop do
                    printf(
                        "%s-> %sSelect:%s ",
                        Color.CC, Color.N, Color.GG,
                    )

                    input = $stdin.gets.to_s.strip
                    break if
                        input.downcase == "mpfly::return"

                    selected = nil
                    if input.match?(
                        /^\d+$/,
                    )
                        idx = input.to_i
                        if idx > 0 &&
                            idx <= matches.size
                                selected = matches[idx - 1]
                        end
                    else
                        selected = input if
                            matches.include?(input)
                    end

                    if selected
                        item = playwith.delete(selected)
                        playwith.unshift(item)
                        printf(
                            "%s[*] %sPrioritized: %s%s%s\n",
                            Color.B, Color.N, Color.GG, selected, Color.N,
                        )
                        break
                    else
                        printf(
                            "%s[!] %sInvalid selection!\n",
                            Color.R, Color.N,
                        )
                    end
                end
            end
            playwith
        end
    end
end

# Copyright (c) 2026 Zeronetsec