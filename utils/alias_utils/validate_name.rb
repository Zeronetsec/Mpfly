# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/missing_argument'

module AliasUtils
    module ValidateName
        def self.execute(name)
            if name.nil? || name.empty?
                MissingArgument.execute()
                return false
            end

            unless name.start_with?("@")
                printf(
                    "%s[!] %sAlias name must start with %s@%s\n",
                    Color.R, Color.N, Color.GG, Color.N,
                )
                return false
            end

            true
        end
    end
end

# Copyright (c) 2026 Zeronetsec