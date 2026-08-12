# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/mptrack_alias'
require 'utils/missing_argument'
require 'utils/info_utils/show_jmod_info'
require 'utils/info_utils/show_fmod_info'

module Info
    def self.execute(*args)
        args = args.flatten
        args.shift
        target = args.join(" ").strip

        if target.empty?
            MissingArgument.execute()
            return
        end

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
            InfoUtils::ShowFmodInfo.execute(target)
        elsif File.exist?(target) &&
            target.end_with?(".json")
                InfoUtils::ShowJmodInfo.execute(target)
        else
            printf(
                "%s[!] %sInvalid target path!%s\n",
                Color.R, Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec