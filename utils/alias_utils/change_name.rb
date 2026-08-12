# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/alias_utils/check_file_exists'
require 'utils/alias_utils/validate_name'

module AliasUtils
    module ChangeName
        def self.execute(old_name, new_name)
            new_name = new_name.to_s.split(" ").first || ""

            return unless
                AliasUtils::ValidateName.execute(old_name)

            return unless
                AliasUtils::ValidateName.execute(new_name)

            AliasUtils::CheckFileExists.execute()
            lines = File.readlines(Variable.MpTrack)
            exists = lines.any? do |line|
                line.include?("->") &&
                    line.split(
                        "->", 2,
                    )[0].strip == new_name
            end

            if exists
                printf(
                    "%s[!] %sAlias name: %s%s %salready exists!\n",
                    Color.R, Color.N, Color.GG, new_name, Color.N,
                )
                return
            end

            found = false
            stored_value = ""

            new_lines = lines.map do |line|
                if line.include?("->") &&
                    line.split(
                        "->", 2,
                    )[0].strip == old_name
                        found = true
                        stored_value = line.split("->", 2)[1].strip
                        "#{new_name} -> #{stored_value}\n"
                else
                    line
                end
            end

            if found
                File.open(
                    Variable.MpTrack,
                    "w",
                ) do |f|
                    f.puts(new_lines)
                end
                printf(
                    "%s[+] %sRenamed: %s%s %s-> %s%s%s\n",
                    Color.GG, Color.N, Color.GG, old_name, Color.DG,
                    Color.GG, new_name, Color.N,
                )
            else
                printf(
                    "%s[!] %sAlias: %s%s %snot found!\n",
                    Color.R, Color.N, Color.GG, old_name, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec