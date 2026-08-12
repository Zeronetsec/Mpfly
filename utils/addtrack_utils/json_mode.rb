# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'fileutils'
require 'utils/color'
require 'utils/addtrack_utils/prompt'

module AddtrackUtils
    module JsonMode
        def self.execute(file)
            track_count = 0
            dir = File.dirname(file)

            unless File.directory?(dir)
                FileUtils.mkdir_p(dir)
            end

            data = {}
            if File.exist?(file)
                begin
                    data = JSON.parse(File.read(file))
                rescue JSON::ParserError
                    printf(
                        "%s[!] %sParsing error on: %s%s%s\n",
                        Color.R, Color.N, Color.GG, file, Color.N,
                    )
                end
            end

            data["Playlist"] ||= ""
            data["Tracks"] ||= []

            if data["Playlist"].empty?
                printf(
                    "%s[*] %sCreating%s/%sUpdating: %s%s%s\n",
                    Color.B, Color.N, Color.DG, Color.N, Color.GG, file, Color.N,
                )

                playinit = AddtrackUtils::Prompt.execute(
                    "#{Color.CC}-> #{Color.N}Playinit:#{Color.GG} ",
                )

                data["Playlist"] = playinit
            end

            printf(
                "%sHandler:\n",
                Color.N,
            )

            printf(
                "%s- %smpfly::return %s-> %sTrack::Name%s, %s*::PlayWith::*%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.DG,
                Color.CC, Color.N,
            )

            loop do
                track_name = AddtrackUtils::Prompt.execute(
                    "#{Color.CC}-> #{Color.N}Track#{Color.DG}::#{Color.N}Name:#{Color.GG} ",
                )

                break if track_name.downcase == "mpfly::return"

                playwith = []
                idx = 1
                loop do
                    pw = AddtrackUtils::Prompt.execute(
                        "#{Color.CC}-> #{Color.N}#{track_name}#{Color.DG}::#{Color.N}PlayWith#{Color.DG}::#{Color.N}#{idx}:#{Color.GG} ",
                    )

                    break if pw.downcase == "mpfly::return"
                    playwith << pw
                    idx += 1
                end

                data["Tracks"] << {
                    "Track" => track_name,
                    "PlayWith" => playwith,
                }
                track_count += 1

                File.open(file, "w") do |f|
                    f.puts(
                        JSON.pretty_generate(data),
                    )
                end

                printf(
                    "%s[*] %sSet value:\n",
                    Color.B, Color.N,
                )

                printf(
                    "    %s├── %sname: %s%s%s\n",
                    Color.DG, Color.WW, Color.GG, track_name, Color.N,
                )

                printf(
                    "    %s├── %sPlaywith: %s%s%s\n",
                    Color.DG, Color.N, Color.GG, playwith.join(", "), Color.N,
                )

                printf(
                    "    %s└──> %s%s%s\n",
                    Color.DG, Color.GG, file, Color.N,
                )
            end
            
            printf(
                "%s[+] %d %strack added to %s%s%s\n",
                Color.GG, track_count, Color.N, Color.GG, file, Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec