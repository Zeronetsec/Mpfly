# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/write_history'
require 'utils/play_utils/play_direct'

module PlayUtils
    module PlayWithFallbacks
        def self.execute(track_name, sources, playlist_name = nil)
            printf("\n")
            printf(
                "%s[*] %sPlaying: %s%s%s\n",
                Color.B, Color.N, Color.GG, track_name, Color.N,
            )

            WriteHistory.execute(
                playlist_name,
                track_name,
                sources,
            )

            success = false
            sources.each_with_index do |src, index|
                printf(
                    "%s[%s%d%s] %sPlay with: %s%s%s\n",
                    Color.DG, Color.GG, (index + 1), Color.DG,
                    Color.N, Color.GG, src, Color.N,
                )

                unless src.start_with?(
                    "http://",
                    "https://",
                )
                    unless File.exist?(src)
                        printf(
                            "%s[!] %sFile: %s%s %snot found!\n",
                            Color.R, Color.N, Color.GG, src, Color.N,
                        )
                        next
                    end
                end

                if PlayUtils::PlayDirect.execute(
                    src,
                    track_name,
                )
                    success = true
                    break
                end
            end

            unless success
                printf(
                    "%s[!] %sTrack: %s%s %sall source failed!\n",
                    Color.R, Color.N, Color.GG, track_name, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec