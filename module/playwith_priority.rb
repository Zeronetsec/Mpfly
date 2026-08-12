# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/mptrack_alias'
require 'utils/missing_argument'
require 'utils/playwith_priority_utils/show_fmod'
require 'utils/playwith_priority_utils/show_jmod'
require 'utils/playwith_priority_utils/process_fmod'
require 'utils/playwith_priority_utils/process_jmod'

module PlaywithPriority
    def self.execute(*args)
        args = args.flatten
        args.shift

        if args.empty?
            MissingArgument.execute()
            return
        end

        target = args.shift.to_s.strip
        prio = args.shift&.strip

        if target.start_with?("@")
            resolved_target = MptrackAlias.execute(
                Variable.MpTrack,
                target,
            )

            if resolved_target.nil? ||
                resolved_target.empty?
                    printf(
                        "%s[!] %sAlias: %s%s %snot found!\n",
                        Color.R, Color.N, Color.GG, target, Color.N,
                    )
                    return
            end

            printf(
                "%s[*] %sResolved input alias: %s%s %s-> %s%s%s\n",
                Color.B, Color.N, Color.GG, target, Color.DG,
                Color.GG, resolved_target, Color.N,
            )

            target = resolved_target
        end

        if File.directory?(target)
            if prio.nil? || prio.empty?
                PlaywithPriorityUtils::ShowFmod.execute(target)
            else
                PlaywithPriorityUtils::ProcessFmod.execute(
                    target,
                    prio,
                )
            end
        elsif File.exist?(target) &&
            target.end_with?(
                ".json",
            )
                if prio.nil? || prio.empty?
                    PlaywithPriorityUtils::ShowJmod.execute(target)
                else
                    PlaywithPriorityUtils::ProcessJmod.execute(
                        target,
                        prio,
                    )
                end
        else
            printf(
                "%s[!] %sTarget: %s%s %snot found!\n",
                Color.R, Color.N, Color.GG, target, Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec