# https://github.com/Zeronetsec/Mpfly

require 'utils/color'

module PlaywithPriorityUtils
    module RenderShow
        def self.execute(track_name, playwith)
            printf(
                "%s[*] %sTrack: %s%s%s\n",
                Color.B, Color.N, Color.GG,
                track_name || "unknown",
                Color.N,
            )

            if playwith.nil? || playwith.empty?
                printf(
                    "    %s└── %s(%sempty%s)%s\n",
                    Color.DG, Color.DG, Color.YY, Color.DG, Color.N,
                )
                return
            end

            playwith.each_with_index do |src, i|
                branch = (i == playwith.size - 1) ?
                    "└──" :
                    "├──"

                printf(
                    "    %s%s %s%d. %s%s%s\n",
                    Color.DG, branch,
                    Color.WW, i + 1,
                    Color.GG, src, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec