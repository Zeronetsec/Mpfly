# https://github.com/Zeronetsec/Mpfly

require 'fileutils'
require 'shellwords'
require 'utils/color'

module DownloadUtils
    module Engine
        def self.execute(tracks, out_dir)
            tracks.each_with_index do |trk, idx|
                track_name = trk["Track"]
                playwith = trk["PlayWith"] || []
                
                url = playwith.find {
                    |s| s.start_with?(
                        "http://",
                        "https://",
                    )
                }
                
                if url.nil?
                    printf(
                        "%s[!] %sSkipping: %s%s %s(%sno valid url%s)%s\n",
                        Color.YY, Color.N, Color.GG, track_name, Color.DG,
                        Color.N, Color.DG, Color.N,
                    )
                    next
                end

                if track_name == "__URL__"
                    display_name = url
                    output_template = File.join(
                        out_dir,
                        "%(title)s.%(ext)s",
                    )
                else
                    display_name = track_name
                    safe_name = track_name.gsub(
                        /[^0-9A-Za-z.\- ]/, '_',
                    )

                    output_template = File.join(
                        out_dir,
                        "#{safe_name}.%(ext)s",
                    )
                end

                printf(
                    "%s[*] %sDownloading %s(%s%d%s/%s%d%s)%s: %s%s%s\n",
                    Color.B, Color.N, Color.DG,
                    Color.CC, idx + 1, Color.DG,
                    Color.GG, tracks.size, Color.DG,
                    Color.N, Color.GG, display_name, Color.N,
                )

                cmd = "yt-dlp -f bestaudio -x -o #{Shellwords.escape(output_template)} #{Shellwords.escape(url)} --quiet --no-warnings"
                system(cmd)

                if $?.success?
                    printf(
                        "    %s└── %ssuccess\n",
                        Color.DG, Color.GG,
                    )
                else
                    printf(
                        "    %s└── %sfailed\n",
                        Color.DG, Color.R,
                    )
                end
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec