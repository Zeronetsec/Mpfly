# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'

module SearchUtils
    module LoadJsonMode
        def self.execute(file)
            unless File.exist?(file)
                printf(
                    "%s[!] %sFile: %s%s %snot found!\n",
                    Color.R, Color.N, Color.GG, file, Color.N,
                )
                return []
            end

            begin
                data = JSON.parse(File.read(file))
                return data["Tracks"] || []
            rescue JSON::ParserError
                printf(
                    "%s[!] %sInvalid json: %s%s%s\n",
                    Color.R, Color.N, Color.GG, file, Color.N,
                )
                return []
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec