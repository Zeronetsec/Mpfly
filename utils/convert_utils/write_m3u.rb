# https://github.com/Zeronetsec/Mpfly

require 'utils/color'

module ConvertUtils
    module WriteM3u
        def self.execute(data, out_file, input_target, format_ext)
            ext = ".#{format_ext}"
            out_file += ext unless out_file.end_with?(ext)

            File.open(out_file, "w") do |f|
                f.puts("#EXTM3U")
                data["Tracks"].each do |t|
                    track_name = t["Track"] || "unknown"
                    urls = t["PlayWith"] || []
                    urls.each do |url|
                        f.puts(
                            "#EXTINF:-1,#{track_name}",
                        )
                        f.puts(url)
                    end
                end
            end

            printf(
                "%s[*] %sConvert: %s%s%s\n",
                Color.B, Color.N, Color.GG, input_target, Color.N,
            )

            printf(
                "%s[+] %sSaved: %s%s %s(%s%d %stracks%s)%s\n",
                Color.GG, Color.N, Color.GG, out_file, Color.DG,
                Color.CC, data["Tracks"].size, Color.WW, Color.DG,
                Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec