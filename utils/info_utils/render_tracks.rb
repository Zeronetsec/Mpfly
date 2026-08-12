# https://github.com/Zeronetsec/Mpfly

require 'utils/color'

module InfoUtils
    module RenderTracks
        def self.execute(tracks)
            tracks.each_with_index do |trk, track_idx|
                is_last_track = (track_idx == tracks.size - 1)
                t_branch = is_last_track ?
                    "└──" :
                    "├──"

                t_pad = is_last_track ?
                    "    " :
                    "│   "

                printf(
                    "    %s%s %strack: %s%s%s\n",
                    Color.DG, t_branch, Color.WW, Color.GG,
                    trk["Track"], Color.N,
                )

                printf(
                    "    %s%s└── %splaywith:%s\n",
                    Color.DG, t_pad, Color.WW, Color.N,
                )

                sources = trk["PlayWith"] || []
                sources.each_with_index do |src, src_idx|
                    is_last_src = (src_idx == sources.size - 1)
                    s_branch = is_last_src ?
                        "└──" :
                        "├──"

                    domain = src.match?(
                        %r{https?://([^/]+)},
                    ) ? src.match(
                        %r{https?://([^/]+)},
                    )[1] : "local"

                    printf(
                        "    %s%s    %s %s%s: %s%s%s\n", 
                        Color.DG, t_pad, s_branch, Color.WW, domain,
                        Color.GG, src, Color.N,
                    )
                end
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec