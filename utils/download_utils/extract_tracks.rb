# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'

module DownloadUtils
    module ExtractTracks
        def self.execute(target)
            tracks = []
            if target.match?(
                /^https?:\/\//i,
            )
                tracks << {
                    "Track" => "__URL__",
                    "PlayWith" => [target],
                }
            elsif File.directory?(target)
                Dir.glob(
                    File.join(
                        target,
                        "*.json",
                    )
                ).reject {
                    |f| File.basename(f) == "__playinit__.json"
                }.sort.each do |file|
                    begin
                        data = JSON.parse(
                            File.read(file),
                        )

                        tracks << data if
                            data["Track"] &&
                            data["PlayWith"]
                    rescue JSON::ParserError
                    end
                end
            elsif File.exist?(target) &&
                target.end_with?(".json")
                    begin
                        data = JSON.parse(
                            File.read(target),
                        )
                        tracks = data["Tracks"] || []
                    rescue JSON::ParserError
                        printf(
                            "%s[!] %sInvalid json: %s%s%s\n",
                            Color.R, Color.N, Color.GG, target, Color.N,
                        )
                    end
            else
                printf(
                    "%s[!] %sTarget: %s%s %snot found or invalid!\n",
                    Color.R, Color.N, Color.GG, target, Color.N,
                )
            end
            tracks
        end
    end
end

# Copyright (c) 2026 Zeronetsec