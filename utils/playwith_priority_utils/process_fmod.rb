# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'
require 'utils/playwith_priority_utils/reorder_logic'

module PlaywithPriorityUtils
    module ProcessFmod
        def self.execute(dir, prio)
            changed = false
            Dir.glob(
                File.join(
                    dir,
                    "*.json",
                ),
            ).reject {
                |f| File.basename(f) == "__playinit__.json"
            }.sort.each do |file|
                data = JSON.parse(File.read(file))
                original = data["PlayWith"]&.dup
                data["PlayWith"] = PlaywithPriorityUtils::ReorderLogic.execute(
                    data["Track"],
                    data["PlayWith"],
                    prio,
                )
                
                if original != data["PlayWith"]
                    File.write(
                        file,
                        JSON.pretty_generate(data),
                    )
                    changed = true
                end
            end

            if changed
                printf(
                    "%s[+] %sPriority updated.\n",
                    Color.GG, Color.N,
                )

                printf(
                    "%s[+] %sSaved: %s%s%s\n",
                    Color.GG, Color.N, Color.GG, dir, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec