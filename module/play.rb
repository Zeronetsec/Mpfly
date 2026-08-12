# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/patch_conf'
require 'utils/missing_argument'
require 'utils/mptrack_alias'
require 'utils/play_utils/play_single'
require 'utils/play_utils/handle_folder'
require 'utils/play_utils/handle_json_playlist'

module Play
    def self.execute(*args)
        begin
            PatchConf.execute("patch")

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
                    "%s[*] %sResolved alias: %s%s %s-> %s%s%s\n",
                    Color.B, Color.N, Color.GG, target, Color.DG,
                    Color.GG, resolved_target, Color.N,
                )

                target = resolved_target
            end

            if target.start_with?(
                "http://",
                "https://",
            )
                PlayUtils::PlaySingle.execute(target)
            elsif File.directory?(target)
                PlayUtils::HandleFolder.execute(target)
            elsif File.exist?(target)
                if target.end_with?(
                    ".json",
                )
                    PlayUtils::HandleJsonPlaylist.execute(target)
                else
                    PlayUtils::PlaySingle.execute(target)
                end
            else
                printf(
                    "%s[!] %sTarget: %s%s %snot found!\n",
                    Color.R, Color.N, Color.GG, target, Color.N,
                )
            end
        rescue Interrupt
            printf("\n")
            printf(
                "%s[*] %sInterrupted by user.\n",
                Color.B, Color.N,
            )
            exit(0)
        ensure
            PatchConf.execute("unpatch")
        end
    end
end

# Copyright (c) 2026 Zeronetsec