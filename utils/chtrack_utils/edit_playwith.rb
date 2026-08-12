# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/chtrack_utils/render_tree_list'
require 'utils/chtrack_utils/prompt_action'

module ChtrackUtils
    module EditPlaywith
        def self.execute(track_name, playwith_array)
            new_playwith = playwith_array.dup
            
            printf(
                "%sHandler:\n",
                Color.N,
            )

            printf(
                "%s- %smpfly::return %s-> %s*::PlayWith::target%s, %sNew PlayWith value%s, %sNew value for PlayWith::*%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.DG,
                Color.CC, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %smpfly::new::playwith %s-> %s*::PlayWith::target%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %s<num> %s-> %s*::PlayWith::target%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %smpfly::remove %s-> %s*::PlayWith::*%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %smpfly::edit %s-> %s*::PlayWith::*%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            loop do
                printf(
                    "%s[*] %sCurrent PlayWith for %s%s%s:\n",
                    Color.B, Color.N, Color.GG, track_name, Color.N,
                )

                ChtrackUtils::RenderTreeList.execute(new_playwith)
                prompt_label = "#{Color.N}#{track_name}#{Color.DG}::#{Color.N}PlayWith#{Color.DG}::#{Color.N}target"
                idx_str = ChtrackUtils::PromptAction.execute(prompt_label)
                break if
                    idx_str.downcase == "mpfly::return"

                if idx_str.downcase == "mpfly::new::playwith" ||
                    idx_str.downcase == "add"
                        val = ChtrackUtils::PromptAction.execute(
                            "#{Color.N}New PlayWith value",
                        )

                        new_playwith << val unless
                            val.downcase == "mpfly::return" ||
                            val.empty?
                        next
                end

                idx = idx_str.to_i - 1
                if idx >= 0 && idx < new_playwith.size
                    action = ChtrackUtils::PromptAction.execute(
                        "#{Color.N}#{track_name}#{Color.DG}::#{Color.N}PlayWith#{Color.DG}::#{Color.N}#{idx + 1}",
                        new_playwith[idx],
                    )

                    if action.downcase == "mpfly::remove"
                        new_playwith.delete_at(idx)
                    elsif action.downcase == "mpfly::edit"
                        new_val = ChtrackUtils::PromptAction.execute(
                            "#{Color.N}New value for PlayWith#{Color.DG}::#{Color.N}#{idx + 1}",
                        )
                        new_playwith[idx] = new_val unless
                            new_val.downcase == "mpfly::return" ||
                            new_val.empty?
                    elsif !action.empty?
                        new_playwith[idx] = action
                    end
                else
                    printf(
                        "%s[!] %sInvalid target!\n",
                        Color.R, Color.N,
                    )
                end
            end
            new_playwith
        end
    end
end

# Copyright (c) 2026 Zeronetsec