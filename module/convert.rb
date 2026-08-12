# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/mptrack_alias'
require 'utils/missing_argument'
require 'utils/convert_utils/read_folder'
require 'utils/convert_utils/read_json'
require 'utils/convert_utils/read_m3u'
require 'utils/convert_utils/write_folder'
require 'utils/convert_utils/write_json'
require 'utils/convert_utils/write_m3u'

module Convert
    def self.execute(*args)
        args = args.flatten
        args.shift

        to_idx = args.index("--to")
        out_idx = args.index("--out")

        if to_idx.nil? || out_idx.nil?
            MissingArgument.execute()
            return
        end

        input_end_idx = [
            to_idx,
            out_idx,
        ].min

        input_target = args[
            0...input_end_idx,
        ].join(" ").strip

        if to_idx < out_idx
            to_format = args[
                (to_idx + 1)...out_idx,
            ].join(" ").strip.downcase

            out_target = args[
                (out_idx + 1)..-1,
            ].join(" ").strip
        else
            out_target = args[
                (out_idx + 1)...to_idx,
            ].join(" ").strip

            to_format = args[
                (to_idx + 1)..-1,
            ].join(" ").strip.downcase
        end

        if input_target.empty? ||
            to_format.empty? ||
            out_target.empty?
                MissingArgument.execute()
                return
        end

        if input_target.start_with?("@")
            resolved_target = MptrackAlias.execute(
                Variable.MpTrack,
                input_target,
            )

            if resolved_target.nil? ||
                resolved_target.empty?
                    printf(
                        "%s[!] %sAlias: %s%s %snot found!\n",
                        Color.R, Color.N, Color.GG, input_target, Color.N,
                    )
                    return
            end

            printf(
                "%s[*] %sResolved input alias: %s%s %s-> %s%s%s\n",
                Color.B, Color.N, Color.GG, input_target, Color.DG,
                Color.GG, resolved_target, Color.N,
            )

            input_target = resolved_target
        end

        data = nil
        if File.directory?(input_target)
            data = ConvertUtils::ReadFolder.execute(
                input_target,
            )
        elsif File.exist?(input_target)
            if input_target.end_with?(
                ".json",
            )
                data = ConvertUtils::ReadJson.execute(
                    input_target,
                )
            elsif input_target.end_with?(
                ".m3u",
                ".m3u8",
            )
                data = ConvertUtils::ReadM3u.execute(
                    input_target,
                )
            else
                printf(
                    "%s[!] %sInput: %s%s %sis not a valid folder, .json, .m3u, or .m3u8 file!\n",
                    Color.R, Color.N, Color.GG, input_target, Color.N,
                )
                return
            end
        else
            printf(
                "%s[!] %sInput: %s%s %snot found!\n",
                Color.R, Color.N, Color.GG, input_target, Color.N,
            )
            return
        end

        return if data.nil?

        case to_format
            when "json"
                ConvertUtils::WriteJson.execute(
                    data,
                    out_target,
                    input_target,
                )
            when "folder"
                ConvertUtils::WriteFolder.execute(
                    data,
                    out_target,
                    input_target,
                )
            when "m3u", "m3u8"
                ConvertUtils::WriteM3u.execute(
                    data,
                    out_target,
                    input_target,
                    to_format,
                )
            else
                printf(
                    "%s[!] %sUnknown target format: %s%s%s\n",
                    Color.R, Color.N, Color.GG, to_format, Color.N,
                )
        end
    end
end

# Copyright (c) 2026 Zeronetsec