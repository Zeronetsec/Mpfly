# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/alias_utils/check_file_exists'
require 'utils/alias_utils/validate_name'

module AliasUtils
    module RemoveAlias
        def self.execute(name)
            return unless
                AliasUtils::ValidateName.execute(name)

            AliasUtils::CheckFileExists.execute()
            lines = File.readlines(Variable.MpTrack)
            new_lines = []
            found = false

            lines.each do |line|
                if line.include?("->") &&
                    line.split(
                        "->", 2,
                    )[0].strip == name
                        found = true
                        next
                end
                new_lines << line
            end

            if found
                File.open(
                    Variable.MpTrack,
                    "w",
                ) do |f|
                    f.puts(new_lines)
                end
                printf(
                    "%s[-] %sAlias: %s%s %sremoved\n",
                    Color.YY, Color.N, Color.GG, name, Color.N,
                )
            else
                printf(
                    "%s[!] %sAlias: %s%s %snot found!\n",
                    Color.R, Color.N, Color.GG, name, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec