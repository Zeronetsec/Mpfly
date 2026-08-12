# https://github.com/Zeronetsec/Mpfly

require 'fileutils'
require 'utils/color'
require 'utils/variable'
require 'utils/mptrack_alias'
require 'utils/missing_argument'
require 'utils/download_utils/extract_tracks'
require 'utils/download_utils/engine'
require 'utils/download_utils/compress'

module Download
    def self.execute(*args)
        args = args.flatten
        args.shift

        if args.empty?
            MissingArgument.execute()
            return
        end

        out_dir = nil
        compress_mode = nil

        compress_idx = args.index("--compress")
        if compress_idx &&
            compress_idx + 1 < args.length
                compress_mode = args[compress_idx + 1]
                args[
                    compress_idx..compress_idx + 1,
                ] = [nil, nil]
        end

        out_idx = args.index("--out")
        if out_idx &&
            out_idx + 1 < args.length
                out_dir = args[out_idx + 1]
                args[
                    out_idx..out_idx + 1,
                ] = [nil, nil]
        end

        args.compact!
        target = args.join(" ").strip

        if target.empty? || out_dir.nil?
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

        out_dir = File.expand_path(out_dir)
        FileUtils.mkdir_p(out_dir) unless
            File.directory?(out_dir)

        tracks = DownloadUtils::ExtractTracks.execute(
            target,
        )

        if tracks.empty?
            printf(
                "%s[!] %sNo valid tracks to download!\n",
                Color.R, Color.N,
            )
            return
        end

        printf(
            "%s[*] %sStarting download for: %s%d %stracks to %s%s%s...\n",
            Color.B, Color.N, Color.GG, tracks.size, Color.N,
            Color.GG, out_dir, Color.N,
        )

        DownloadUtils::Engine.execute(
            tracks,
            out_dir,
        )

        if compress_mode
            DownloadUtils::Compress.execute(
                out_dir,
                compress_mode,
            )
        end

        printf(
            "%s[+] %sAll download and compression tasks completed!\n",
            Color.GG, Color.N,
        )
    end
end

# Copyright (c) 2026 Zeronetsec