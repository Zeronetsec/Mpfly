# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'
require 'utils/play_utils/check_shuffle'
require 'utils/play_utils/play_with_fallbacks'

module PlayUtils
    module HandleJsonPlaylist
        def self.execute(file)
            begin
                data = JSON.parse(File.read(file))
                playlist_name = data["Playlist"] ||
                    File.basename(
                        file,
                        ".json",
                    )

                tracks = data["Tracks"] || []
                if tracks.empty?
                    printf(
                        "%s[!] %sEmpty playlist!\n",
                        Color.R, Color.N,
                    )
                    return
                end

                shuffle_mode = PlayUtils::CheckShuffle.execute()
                printf(
                    "%s[*] %sPlaylist: %s%s%s\n",
                    Color.B, Color.N, Color.GG, playlist_name, Color.N,
                )

                printf(
                    "    %s├── %smode: %sjmod%s\n",
                    Color.DG, Color.WW, Color.GG, Color.N,
                )

                printf(
                    "    %s└── %sshuffle: %s%s\n",
                    Color.DG, Color.WW,
                    shuffle_mode ?
                        Color.GG + "on" :
                        Color.YY + "off",
                    Color.N,
                )

                loop do
                    current_queue = shuffle_mode ?
                        tracks.shuffle :
                        tracks

                    current_queue.each do |item|
                        track_name = item["Track"] ||
                            "unknown track"

                        sources = item["PlayWith"] || []
                        if sources.empty?
                            printf(
                                "%s[!] %sFile: %s%s %smissing array %sPlayWith%s\n",
                                Color.R, Color.N, Color.GG, track_name,
                                Color.N, Color.GG, Color.N,
                            )
                            next
                        end

                        PlayUtils::PlayWithFallbacks.execute(
                            track_name,
                            sources,
                            playlist_name,
                        )
                    end
                end
            rescue JSON::ParserError
                printf(
                    "%s[!] %sFailed reading json format: %s%s%s\n",
                    Color.R, Color.N, Color.GG, file, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec