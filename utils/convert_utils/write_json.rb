# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'

module ConvertUtils
    module WriteJson
        def self.execute(data, out_file, input_target)
            out_file += ".json" unless
                out_file.end_with?(".json")

            File.open(out_file, "w") do |f|
                f.puts(
                    JSON.pretty_generate(data),
                )
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