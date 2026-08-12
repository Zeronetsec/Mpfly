# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'

module SearchUtils
    module LoadFolderMode
        def self.execute(dir)
            unless File.directory?(dir)
                printf(
                    "%s[!] %sFolder: %s%s %snot found!\n",
                    Color.R, Color.N, Color.GG, dir, Color.N,
                )
                return []
            end
            
            tracks = []
            json_files = Dir.glob(
                File.join(
                    dir,
                    "*.json",
                ),
            ).reject {
                |f| File.basename(f) == "__playinit__.json"
            }.sort

            json_files.each do |file|
                begin
                    data = JSON.parse(File.read(file))
                    tracks << data if data["Track"] &&
                        data["PlayWith"]
                rescue JSON::ParserError
                end
            end
            tracks
        end
    end
end

# Copyright (c) 2026 Zeronetsec