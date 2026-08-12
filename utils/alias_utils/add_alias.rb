# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/missing_argument'
require 'utils/alias_utils/check_file_exists'
require 'utils/alias_utils/validate_name'
require 'utils/alias_utils/clean_quotes'

module AliasUtils
    module AddAlias
        def self.execute(name, value)
            return unless AliasUtils::ValidateName.execute(name)
            
            if value.nil? || value.empty?
                MissingArgument.execute()
                return
            end

            AliasUtils::CheckFileExists.execute()
            lines = File.readlines(Variable.MpTrack)
            exists = lines.any? do |line|
                line.include?("->") &&
                    line.split(
                        "->", 2,
                    )[0].strip == name
            end

            if exists
                printf(
                    "%s[!] %sAlias: %s%s %salready exists!\n",
                    Color.R, Color.N, Color.GG, name, Color.N,
                )
                return
            end

            formatted_value = "'#{AliasUtils::CleanQuotes.execute(value)}'"
            File.open(
                Variable.MpTrack,
                "a",
            ) do |f|
                f.puts(
                    "#{name} -> #{formatted_value}",
                )
            end

            printf(
                "%s[+] %sAdded: %s%s %s-> %s%s%s\n",
                Color.GG, Color.N, Color.GG, name, Color.DG,
                Color.CC, formatted_value, Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec