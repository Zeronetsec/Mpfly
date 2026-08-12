# https://github.com/Zeronetsec/Mpfly

require 'utils/color'

module ConvertUtils
    module ReadM3u
        def self.execute(input_file)
            begin
                lines = File.readlines(
                    input_file,
                ).map(&:strip).reject(&:empty?)

                playlist_name = File.basename(
                    input_file,
                    ".*",
                )

                tracks = []
                current_track_name = nil

                lines.each do |line|
                    if line.start_with?("#EXTINF:")
                        current_track_name = line.split(
                            ",", 2,
                        )[1] || "unknown track"
                    elsif !line.start_with?("#") &&
                        current_track_name
                            tracks << {
                                "Track" => current_track_name.strip,
                                "PlayWith" => [line],
                            }
                            current_track_name = nil
                    end
                end

                if tracks.empty?
                    printf(
                        "%s[!] %sM3U file has no tracks to extract!\n",
                        Color.R, Color.N,
                    )
                    return nil
                end

                return {
                    "Playlist" => playlist_name,
                    "Tracks" => tracks,
                }
            rescue => e
                printf(
                    "%s[!] %sFailed to parse m3u file: %s%s%s\n",
                    Color.R, Color.N, Color.GG, input_file, Color.N,
                )
                return nil
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec