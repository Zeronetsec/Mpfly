# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'
require 'utils/playwith_priority_utils/render_show'

module PlaywithPriorityUtils
    module ShowJmod
        def self.execute(file)
            data = JSON.parse(File.read(file))
            tracks = data["Tracks"] || []
            
            printf(
                "%s[*] %sPlaylist: %s%s%s\n",
                Color.B, Color.N, Color.GG,
                data["Playlist"] || "unknown",
                Color.N,
            )

            tracks.each {
                |t| PlaywithPriorityUtils::RenderShow.execute(
                    t["Track"],
                    t["PlayWith"],
                )
            }
        end
    end
end

# Copyright (c) 2026 Zeronetsec