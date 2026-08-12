# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'
require 'utils/play_utils/check_shuffle'
require 'utils/play_utils/play_with_fallbacks'

module PlayUtils
    module HandleFolder
        def self.execute(path)
            init_file = File.join(
                path,
                "__playinit__.json",
            )

            unless File.exist?(init_file)
                printf(
                    "%s[!] %sFolder: %s%s %smissing %s__playinit__.json%s\n",
                    Color.R, Color.N, Color.GG, path,
                    Color.N, Color.GG, Color.N,
                )
                return
            end

            begin
                init_data = JSON.parse(
                    File.read(init_file),
                )

                playlist_name = init_data["Playlist"] ||
                    File.basename(path)
            rescue JSON::ParserError
                printf(
                    "%s[!] %sWarning: %s%s %sInvalid format!\n",
                    Color.YY, Color.N, Color.GG, init_file, Color.N,
                )
                playlist_name = File.basename(path)
            end

            json_files = Dir.glob(
                File.join(path, "*.json"),
            ).reject {
                |f| f.end_with?(
                    "__playinit__.json",
                )
            }.sort

            if json_files.empty?
                printf(
                    "%s[!] %sEmpty track!\n",
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
                "    %s├── %smode: %sfmod%s\n",
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
                    json_files.shuffle :
                    json_files

                current_queue.each do |file|
                    begin
                        data = JSON.parse(File.read(file))
                        track_name = data["Track"] ||
                            "unknown track"

                        sources = data["PlayWith"] || []
                        if sources.empty?
                            printf(
                                "%s[!] %sFile: %s%s %smissing array %sPlayWith%s\n",
                                Color.R, Color.N, Color.GG, file,
                                Color.N, Color.GG, Color.N,
                            )
                            next
                        end

                        PlayUtils::PlayWithFallbacks.execute(
                            track_name,
                            sources,
                            playlist_name,
                        )
                    rescue JSON::ParserError
                        printf(
                            "%s[!] %sWarning: %s%s %sinvalid format!\n",
                            Color.R, Color.N, Color.GG, file, Color.N,
                        )
                    end
                end
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec