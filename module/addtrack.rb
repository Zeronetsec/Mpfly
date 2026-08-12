# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/mptrack_alias'
require 'utils/missing_argument'
require 'utils/addtrack_utils/json_mode'
require 'utils/addtrack_utils/folder_mode'

module Addtrack
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

        if target.end_with?(".json")
            AddtrackUtils::JsonMode.execute(target)
        else
            AddtrackUtils::FolderMode.execute(target)
        end
    end
end

# Copyright (c) 2026 Zeronetsec