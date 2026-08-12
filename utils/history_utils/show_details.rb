# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/history_utils/read_data'
require 'utils/history_utils/render_details_tree'

module HistoryUtils
    module ShowDetails
        def self.execute()
            data = HistoryUtils::ReadData.execute()
            if data.empty?
                printf(
                    "%s[!] %sHistory is empty!\n",
                    Color.R, Color.N,
                )
                exit(1)
            end

            last_entry = data.last
            last_played = "#{last_entry[:date]} #{last_entry[:time]}"

            playlists_all = data.map {
                |d| d[:playlist]
            }.reject {
                |p| p == "none"
            }

            most_overall_playlist = playlists_all.empty? ?
                "none" :
                playlists_all.tally.max_by {
                    |_, v| v
                }.first

            grouped = {}
            data.each do |d|
                pl = d[:playlist]
                sg = d[:song]
                pw = d[:playwith]

                grouped[pl] ||= {}
                grouped[pl][sg] ||= []
                grouped[pl][sg].concat(pw).uniq!
            end

            pl_keys = grouped.keys
            total_playlists = pl_keys.reject {
                |k| k == "none"
            }.size

            printf(
                "%s[*] %sHistory details:\n",
                Color.B, Color.N,
            )

            printf(
                "    %s├── %scurrent playing: %s%s%s\n",
                Color.DG, Color.WW, Color.GG, last_played, Color.N,
            )

            printf(
                "    %s└── %sfrequently played playlist: %s%s%s\n",
                Color.DG, Color.WW, Color.GG, most_overall_playlist, Color.N,
            )

            HistoryUtils::RenderDetailsTree.execute(
                grouped,
                data,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec