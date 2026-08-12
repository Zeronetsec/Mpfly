# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'
require 'utils/info_utils/render_tracks'

module InfoUtils
    module ShowFmodInfo
        def self.execute(dir)
            init_file = File.join(
                dir,
                "__playinit__.json",
            )

            playlist_name = File.exist?(init_file) ?
                JSON.parse(
                    File.read(init_file),
                )["Playlist"] : File.basename(dir)

            json_files = Dir.glob(
                File.join(dir, "*.json"),
            ).reject {
                |f| File.basename(f) == "__playinit__.json"
            }.sort

            tracks = json_files.map {
                |f|
                begin
                    JSON.parse(File.read(f))
                rescue JSON::ParserError
                    nil
                end
            }.compact.select {
                |trk| trk.is_a?(Hash) &&
                    trk["Track"] &&
                    !trk["Track"].to_s.strip.empty?
            }

            printf(
                "%s[*] %sPlaylist: %s%s\n",
                Color.B, Color.N, Color.GG, playlist_name, Color.N,
            )

            printf(
                "    %s├── %smode: %sfmod%s\n",
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