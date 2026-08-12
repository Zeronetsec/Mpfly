# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'
require 'utils/playwith_priority_utils/reorder_logic'

module PlaywithPriorityUtils
    module ProcessJmod
        def self.execute(file, prio)
            data = JSON.parse(File.read(file))
            tracks = data["Tracks"] || []
            changed = false
            
            tracks.each do |trk|
                original = trk["PlayWith"]&.dup
                trk["PlayWith"] = PlaywithPriorityUtils::ReorderLogic.execute(
                    trk["Track"],
                    trk["PlayWith"],
                    prio,
                )

                changed = true if
                    original != trk["PlayWith"]
            end

            if changed
                File.write(
                    file,
                    JSON.pretty_generate(data),
                )

                printf(
                    "%s[+] %sPriority updated.\n",
                    Color.GG, Color.N,
                )

                printf(
                    "%s[+] %sSaved: %s%s%s\n",
                    Color.GG, Color.N, Color.GG, file, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec