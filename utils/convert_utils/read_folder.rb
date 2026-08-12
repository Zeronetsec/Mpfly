# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'

module ConvertUtils
    module ReadFolder
        def self.execute(input_dir)
            init_file = File.join(
                input_dir,
                "__playinit__.json",
            )

            unless File.exist?(init_file)
                printf(
                    "%s[!] %sFolder: %s%s %smissing %s__playinit__.json%s\n",
                    Color.R, Color.N, Color.GG, input_dir,
                    Color.N, Color.GG, Color.N,
                )
                return nil
            end

            begin
                init_data = JSON.parse(
                    File.read(init_file),
                )

                playlist_name = init_data["Playlist"] ||
                    File.basename(input_dir)

                json_files = Dir.glob(
                    File.join(
                        input_dir,
                        "*.json",
                    ),
                ).reject {
                    |f| f.end_with?("__playinit__.json")
                }.sort
                
                if json_files.empty?
                    printf(
                        "%s[!] %sFolder contains no track JSON files!\n",
                        Color.R, Color.N,
                    )
                    return nil
                end

                tracks_array = []
                json_files.each do |file|
                    begin
                        data = JSON.parse(File.read(file))
                        if data["Track"] && data["PlayWith"]
                            tracks_array << data
                        end
                    rescue JSON::ParserError
                        printf(
                            "%s[!] %sWarning: %s%s %sskipped %s(%sinvalid json%s)%s\n",
                            Color.YY, Color.N, Color.GG, file, Color.N, Color.DG,
                            Color.GG, Color.DG, Color.N,
                        )
                    end
                end

                return {
                    "Playlist" => playlist_name,
                    "Tracks" => tracks_array,
                }

            rescue JSON::ParserError
                printf(
                    "%s[!] %sParsing: %s__playinit__.json %serror!\n",
                    Color.R, Color.N, Color.GG, Color.N,
                )
                return nil
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec