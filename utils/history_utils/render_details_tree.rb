# https://github.com/Zeronetsec/Mpfly

require 'utils/color'

module HistoryUtils
    module RenderDetailsTree
        def self.execute(grouped, raw_data)
            pl_keys = grouped.keys
            base_pad = "    "

            pl_keys.each_with_index do |pl, pl_idx|
                is_last_pl = (pl_idx == pl_keys.size - 1)
                pl_branch = is_last_pl ?
                    "└──" :
                    "├──"

                display_pl = (pl == "none") ?
                    "single tracks" : pl
                songs = grouped[pl].keys

                pl_songs = raw_data.select {
                    |d| d[:playlist] == pl
                }.map {
                    |d| d[:song]
                }

                most_frequent_track = pl_songs.empty? ?
                    "none" :
                    pl_songs.tally.max_by {
                        |_, v| v
                    }.first

                printf(
                    "    %s%s%s %splaylist: %s%s %s(%s%d %stracks%s)%s\n",
                    Color.DG, base_pad, pl_branch, Color.WW,
                    Color.GG, display_pl, Color.DG,
                    Color.CC, songs.size, Color.WW, Color.DG,
                    Color.N,
                )

                printf(
                    "    %s%s    │   └── %sfrequently heard track: %s%s%s\n",
                    Color.DG, base_pad, Color.WW, Color.GG, most_frequent_track, Color.N,
                )

                songs.each_with_index do |sg, sg_idx|
                    is_last_sg = (sg_idx == songs.size - 1)
                    sg_branch = is_last_sg ?
                        "└──" :
                        "├──"

                    sg_pad = is_last_sg ?
                        "    " :
                        "│   "

                    printf(
                        "    %s%s    %s %strack: %s%s%s\n",
                        Color.DG, base_pad, sg_branch, Color.WW,
                        Color.GG, sg, Color.N,
                    )

                    printf(
                        "    %s%s    %s└── %splaywith:%s\n",
                        Color.DG, base_pad, sg_pad, Color.WW, Color.N,
                    )

                    sources = grouped[pl][sg]
                    sources.each_with_index do |src, src_idx|
                        is_last_src = (src_idx == sources.size - 1)
                        src_branch = is_last_src ?
                            "└──" :
                            "├──"

                        domain = src.match?(
                            %r{https?://([^/]+)},
                        ) ? src.match(
                            %r{https?://([^/]+)},
                        )[1] : "local"

                        track_sources = raw_data.select {
                            |d| d[:song] == sg &&
                                d[:playlist] == pl
                        }.flat_map {
                            |d| d[:playwith]
                        }

                        track_domains = track_sources.map do |s|
                            s.match?(
                                %r{https?://([^/]+)},
                            ) ? s.match(
                                %r{https?://([^/]+)},
                            )[1] : "local"
                        end
                        most_track_domain = track_domains.empty? ?
                            "none" :
                            track_domains.tally.max_by {
                                |_, v| v
                            }.first

                        printf(
                            "    %s%s    %s    %s %s%s: %s%s%s\n",
                            Color.DG, base_pad, sg_pad, src_branch,
                            Color.WW, domain, Color.GG, src, Color.N,
                        )

                        if is_last_src
                            printf(
                                "    %s%s    %s        └── %sfrequently used platform: %s%s%s\n",
                                Color.DG, base_pad, sg_pad, Color.WW, Color.GG, most_track_domain, Color.N,
                            )
                        end
                    end
                end
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec