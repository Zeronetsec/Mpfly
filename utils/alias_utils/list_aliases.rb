# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/alias_utils/check_file_exists'

module AliasUtils
    module ListAliases
        def self.execute()
            AliasUtils::CheckFileExists.execute()

            lines = File.readlines(
                Variable.MpTrack,
            ).reject {
                |l| l.strip.empty? ||
                    l.strip.start_with?("#")
            }

            if lines.empty?
                printf(
                    "%s[!] %sAlias is empty!\n",
                    Color.R, Color.N,
                )
                return
            end

            printf(
                "%s[*] %sAvailable alias:\n",
                Color.B, Color.N,
            )

            lines.each do |line|
                if line.include?("->")
                    parts = line.split(
                        "->", 2,
                    )

                    alias_name = parts[0].strip
                    path_val = parts[1].strip
                    printf(
                        "    %s└── %s%s %s-> %s%s%s\n",
                        Color.DG, Color.GG, alias_name, Color.DG,
                        Color.CC, path_val, Color.N,
                    )
                end
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec