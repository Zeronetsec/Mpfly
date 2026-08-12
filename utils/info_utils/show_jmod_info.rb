# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'
require 'utils/info_utils/render_tracks'

module InfoUtils
    module ShowJmodInfo
        def self.execute(file)
            data = JSON.parse(File.read(file))
            tracks = (data["Tracks"] || []).select {
                |trk| trk.is_a?(Hash) &&
                    trk["Track"] &&
                    !trk["Track"].to_s.strip.empty?
            }

            printf(
                "%s[*] %sPlaylist: %s%s%s\n",
                Color.B, Color.N, Color.GG,
                data["Playlist"] || "unknown", Color.N,
            )

            printf(
                "    %s├── %smode: %sjmod%s\n",
                Color.DG, Color.WW, Color.GG, Color.N,
            )

            printf(
                "    %s└── %stracks: %s%d%s\n",
                Color.DG, Color.WW, Color.GG, tracks.size, Color.N,
            )

            InfoUtils::RenderTracks.execute(tracks)
        end
    end
end

# Copyright (c) 2026 Zeronetsec