# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'
require 'utils/chtrack_utils/render_tree_list'
require 'utils/chtrack_utils/prompt_action'
require 'utils/chtrack_utils/edit_playwith'

module ChtrackUtils
    module JsonMode
        def self.execute(file)
            unless File.exist?(file)
                printf(
                    "%s[!] %sFile: %s%s %snot found!\n",
                    Color.R, Color.N, Color.GG, file, Color.N,
                )
                return
            end

            begin
                data = JSON.parse(File.read(file))
            rescue JSON::ParserError
                printf(
                    "%s[!] %sInvalid json: %s%s%s\n",
                    Color.R, Color.N, Color.GG, file, Color.N,
                )
                return
            end

            data["Playlist"] ||= ""
            data["Tracks"] ||= []

            printf(
                "%sHandler:\n",
                Color.N,
            )

            printf(
                "%s- %smpfly::return %s-> %sTarget%s, %s*::Name%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %smpfly::remove %s-> %s*::Name%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %s__playinit__ %s-> %sTarget%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %s<num>/<name> %s-> %sTarget%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            loop do
                printf(
                    "%s[*] %sAvailable tracks in Playlist: %s%s%s\n",
                    Color.B, Color.N, Color.GG, data["Playlist"], Color.N,
                )

                track_names = data["Tracks"].map {
                    |t| t["Track"]
                }
                ChtrackUtils::RenderTreeList.execute(track_names)
                
                target = ChtrackUtils::PromptAction.execute(
                    "#{Color.N}Target",
                )

                break if target.downcase == "mpfly::return"
                if target.downcase == "__playinit__"
                    new_pl = ChtrackUtils::PromptAction.execute(
                        "#{Color.N}Playlist Name",
                        data["Playlist"],
                    )

                    data["Playlist"] = new_pl unless
                        new_pl.empty?

                    File.open(file, "w") {
                        |f| f.puts(
                            JSON.pretty_generate(data),
                        )
                    }

                    printf(
                        "%s[+] %sPlaylist name updated.\n",
                        Color.GG, Color.N,
                    )
                    next
                end

                idx = nil
                if target.match?(
                    /^\d+$/,
                )
                    num = target.to_i - 1
                    idx = num if num >= 0 &&
                        num < data["Tracks"].size
                else
                    idx = data["Tracks"].find_index {
                        |t| t["Track"] == target
                    }
                end

                unless idx
                    printf(
                        "%s[!] %sTarget: %s%s %snot found!\n",
                        Color.R, Color.N, Color.GG, target, Color.N,
                    )
                    next
                end

                trk = data["Tracks"][idx]
                old_name = trk["Track"]

                new_name = ChtrackUtils::PromptAction.execute(
                    "#{Color.N}#{old_name}#{Color.DG}::#{Color.N}Name",
                    old_name,
                )

                if new_name.downcase == "mpfly::remove"
                    data["Tracks"].delete_at(idx)
                    File.open(file, "w") {
                        |f| f.puts(
                            JSON.pretty_generate(data),
                        )
                    }

                    printf(
                        "%s[-] %sTrack: %s%s %sremoved.\n",
                        Color.YY, Color.N, Color.GG, old_name, Color.N,
                    )
                    next
                end

                trk["Track"] = new_name unless
                    new_name.empty? ||
                    new_name.downcase == "mpfly::return"

                trk["PlayWith"] = ChtrackUtils::EditPlaywith.execute(
                    trk["Track"],
                    trk["PlayWith"] || [],
                )

                data["Tracks"][idx] = trk
                File.open(file, "w") {
                    |f| f.puts(
                        JSON.pretty_generate(data),
                    )
                }

                printf(
                    "%s[+] %sTrack: %s%s %supdated.\n",
                    Color.GG, Color.N, Color.GG, trk["Track"], Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec