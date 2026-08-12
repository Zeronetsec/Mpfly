# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'

module ConvertUtils
    module ReadJson
        def self.execute(input_file)
            begin
                data = JSON.parse(
                    File.read(input_file),
                )

                playlist_name = data["Playlist"] ||
                    File.basename(
                        input_file,
                        ".json",
                    )

                tracks = data["Tracks"] || []
                if tracks.empty?
                    printf(
                        "%s[!] %sJSON file has no tracks to extract!\n",
                        Color.R, Color.N,
                    )
                    return nil
                end

                return {
                    "Playlist" => playlist_name,
                    "Tracks" => tracks,
                }
            rescue JSON::ParserError
                printf(
                    "%s[!] %sFailed to parse json file: %s%s%s\n",
                    Color.R, Color.N, Color.GG, input_file, Color.N,
                )
                return nil
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec