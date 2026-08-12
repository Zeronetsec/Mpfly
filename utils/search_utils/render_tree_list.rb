# https://github.com/Zeronetsec/Mpfly

require 'utils/color'

module SearchUtils
    module RenderTreeList
        def self.execute(items)
            if items.empty?
                printf(
                    "    %s└── (%sempty%s)%s\n",
                    Color.DG, Color.YY, Color.DG, Color.N,
                )
                return
            end

            items.each_with_index do |item, idx|
                branch = (idx == items.size - 1) ?
                    "└──" :
                    "├──"

                printf(
                    "    %s%s %s%d. %s%s%s\n",
                    Color.DG, branch, Color.WW, idx + 1,
                    Color.GG, item, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec