# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/history_utils/read_data'

module HistoryUtils
    module ShowSummary
        def self.execute()
            data = HistoryUtils::ReadData.execute()
            if data.empty?
                printf(
                    "%s[!] %sHistory is empty!\n",
                    Color.R, Color.N,
                )
                return
            end

            last_entry = data.last
            last_played = "#{last_entry[:date]} #{last_entry[:time]}"

            playlists = data.map {
                |d| d[:playlist]
            }.reject {
                |p| p == "none"
            }

            most_playlist = playlists.empty? ?
                "none" :
                playlists.tally.max_by {
                    |_, v| v
                }.first

            uniq_playlists_count = playlists.uniq.size

            tracks = data.map {
                |d| d[:song]
            }

            most_track = tracks.empty? ?
                "none" :
                tracks.tally.max_by {
                    |_, v| v
                }.first
            uniq_tracks_count = tracks.uniq.size

            domains = []
            total_playwith = 0

            data.each do |d|
                d[:playwith].each do |pw|
                    total_playwith += 1
                    if pw.match?(
                        %r{https?://([^/]+)},
                    )
                        domains << pw.match(
                            %r{https?://([^/]+)},
                        )[1]
                    else
                        domains << "local"
                    end
                end
            end

            most_domain = domains.empty? ?
                "none" :
                domains.tally.max_by {
                    |_, v| v
                }.first

            printf(
                "%s[*] %sHistory summary:\n",
                Color.B, Color.N,
            )

            printf(
                "    %s├── %scurrent playing: %s%s%s\n",
                Color.DG, Color.WW, Color.GG, last_played, Color.N,
            )

            printf(
                "    %s├── %splaylist: %s%d%s\n",
                Color.DG, Color.WW, Color.GG, Color.GG, uniq_playlists_count, Color.N,
            ) rescue printf(
                "    %s├── %splaylist: %s%d%s\n",
                Color.DG, Color.WW, Color.GG, uniq_playlists_count, Color.N,
            )

            printf(
                "    %s│   └── %sfrequently played: %s%s%s\n",
                Color.DG, Color.WW, Color.GG, most_playlist, Color.N,
            )

            printf(
                "    %s├── %stracks: %s%d%s\n",
                Color.DG, Color.WW, Color.GG, uniq_tracks_count, Color.N,
            )
            printf(
                "    %s│   └── %soften heard: %s%s%s\n",
                Color.DG, Color.WW, Color.GG, most_track, Color.N,
            )

            printf(
                "    %s└── %splaywith: %s%d loaded%s\n",
                Color.DG, Color.WW, Color.GG, total_playwith, Color.N,
            )
            printf(
                "        %s└── %sfrequently used: %s%s%s\n",
                Color.DG, Color.WW, Color.GG, most_domain, Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec