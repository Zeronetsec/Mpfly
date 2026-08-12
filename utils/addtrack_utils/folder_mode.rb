# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'fileutils'
require 'utils/color'
require 'utils/addtrack_utils/prompt'

module AddtrackUtils
    module FolderMode
        def self.execute(dir)
            track_count = 0
            folder_created = 0

            unless File.directory?(dir)
                FileUtils.mkdir_p(dir)
                folder_created = 1
            end

            init_file = File.join(
                dir,
                "__playinit__.json",
            )

            unless File.exist?(init_file)
                printf(
                    "%s[*] %sCreating: %s%s%s\n",
                    Color.B, Color.N, Color.GG, init_file, Color.N,
                )

                playinit = AddtrackUtils::Prompt.execute(
                    "#{Color.CC}-> #{Color.N}Playinit:#{Color.GG} ",
                )

                File.open(init_file, "w") do |f|
                    f.puts(
                        JSON.pretty_generate(
                            {
                                "Playlist" => playinit,
                            },
                        ),
                    )
                end
            end

            printf(
                "%sHandler:\n",
                Color.N,
            )

            printf(
                "%s- %smpfly::return %s-> %sFilename%s, %s*::PlayWith::*%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.DG,
                Color.CC, Color.N,
            )

            loop do
                filename = AddtrackUtils::Prompt.execute(
                    "#{Color.CC}-> #{Color.N}Filename:#{Color.GG} ",
                )

                break if filename.downcase == "mpfly::return"
                if filename.include?("__playinit__")
                    printf(
                        "%s[!] %sFilename: %s__playinit__ %sillegal filename!\n",
                        Color.R, Color.N, Color.GG, Color.N,
                    )
                    next
                end

                filename = filename.sub(
                    /\.json$/, '',
                )

                file_path = File.join(
                    dir,
                    "#{filename}.json",
                )

                printf(
                    "%s[*] %sCreating: %s%s%s\n",
                    Color.B, Color.N, Color.GG, file_path, Color.N,
                )

                track_name = AddtrackUtils::Prompt.execute(
                    "#{Color.CC}-> #{Color.N}#{filename}#{Color.DG}::#{Color.N}Name:#{Color.GG} ",
                )

                playwith = []
                idx = 1
                loop do
                    pw = AddtrackUtils::Prompt.execute(
                        "#{Color.CC}-> #{Color.N}#{filename}#{Color.DG}::#{Color.N}PlayWith#{Color.DG}::#{Color.N}#{idx}:#{Color.GG} ",
                    )

                    break if pw.downcase == "mpfly::return"
                    playwith << pw
                    idx += 1
                end

                track_data = {
                    "Track" => track_name,
                    "PlayWith" => playwith,
                }

                File.open(file_path, "w") do |f|
                    f.puts(
                        JSON.pretty_generate(track_data),
                    )
                end
                track_count += 1

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
                    Color.DG, Color.WW, Color.GG, playwith.join(", "), Color.N,
                )

                printf(
                    "    %s└──> %s%s%s\n",
                    Color.DG, Color.GG, file_path, Color.N,
                )
            end

            printf(
                "%s[+] %d %sfolder created, %s%d %strack created.\n",
                Color.GG, folder_created, Color.N,
                Color.GG, track_count, Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec