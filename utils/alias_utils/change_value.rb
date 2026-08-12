# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/missing_argument'
require 'utils/alias_utils/check_file_exists'
require 'utils/alias_utils/validate_name'
require 'utils/alias_utils/clean_quotes'

module AliasUtils
    module ChangeValue
        def self.execute(name, new_value)
            return unless
                AliasUtils::ValidateName.execute(name)
            
            if new_value.nil? || new_value.empty?
                MissingArgument.execute()
                return
            end

            AliasUtils::CheckFileExists.execute()
            lines = File.readlines(Variable.MpTrack)
            found = false
            formatted_value = "'#{AliasUtils::CleanQuotes.execute(new_value)}'"

            new_lines = lines.map do |line|
                if line.include?("->") &&
                    line.split(
                        "->", 2,
                    )[0].strip == name
                        found = true
                        "#{name} -> #{formatted_value}\n"
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
                    "%s[+] %sAlias: %s%s %s-> %s%s%s\n",
                    Color.GG, Color.N, Color.GG, name, Color.DG,
                    Color.GG, formatted_value, Color.N,
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