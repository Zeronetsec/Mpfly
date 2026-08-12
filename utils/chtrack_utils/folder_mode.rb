# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'fileutils'
require 'utils/color'
require 'utils/chtrack_utils/render_tree_list'
require 'utils/chtrack_utils/prompt_action'
require 'utils/chtrack_utils/edit_playwith'

module ChtrackUtils
    module FolderMode
        def self.execute(dir)
            unless File.directory?(dir)
                printf(
                    "%s[!] %sFolder: %s%s %snot found!\n",
                    Color.R, Color.N, Color.GG, dir, Color.N,
                )
                return
            end

            printf(
                "%sHandler:\n",
                Color.N,
            )

            printf(
                "%s- %smpfly::return %s-> %sTarget%s, %s*::Name%s, %s*::Filename%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.DG,
                Color.CC, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %smpfly::remove %s-> %s*::Name%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %s__playinit__ %s-> %sTarget%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            printf(
                "%s- %s<num>/<filename> %s-> %sTarget%s\n",
                Color.DG, Color.GG, Color.DG,
                Color.CC, Color.N,
            )

            loop do
                json_files = Dir.glob(
                    File.join(dir, "*.json"),
                ).map {
                    |f| File.basename(f)
                }.sort

                printf(
                    "%s[*] %sAvailable files in %s%s%s:\n",
                    Color.B, Color.N, Color.GG, dir, Color.N,
                )
                ChtrackUtils::RenderTreeList.execute(json_files)

                target = ChtrackUtils::PromptAction.execute(
                    "#{Color.N}Target",
                )

                break if
                    target.downcase == "mpfly::return"

                target_file = nil
                if target.match?(
                    /^\d+$/,
                )
                    num = target.to_i - 1
                    target_file = json_files[num] if
                        num >= 0 &&
                        num < json_files.size
                else
                    target_file = target
                    target_file += ".json" unless
                        target_file.end_with?(".json")
                end

                unless target_file && File.exist?(
                    File.join(
                        dir,
                        target_file,
                    ),
                )
                    printf(
                        "%s[!] %sTarget: %s%s %snot found!%s\n",
                        Color.R, Color.N, Color.GG, target, Color.N,
                    )
                    next
                end

                file_path = File.join(
                    dir,
                    target_file,
                )

                begin
                    data = JSON.parse(
                        File.read(file_path),
                    )
                rescue JSON::ParserError
                    printf(
                        "%s[!] %sInvalid json: %s%s%s\n",
                        Color.R, Color.N, Color.GG, target_file, Color.N,
                    )
                    next
                end

                if target_file == "__playinit__.json"
                    new_pl = ChtrackUtils::PromptAction.execute(
                        "#{Color.N}Playlist Name",
                        data["Playlist"],
                    )

                    data["Playlist"] = new_pl unless
                        new_pl.empty?

                    File.open(file_path, "w") {
                        |f| f.puts(
                            JSON.pretty_generate(data),
                        )
                    }

                    printf(
                        "%s[+] %sPlaylist name updated.\n",
                        Color.GG, Color.N,
                    )
                    next
                end

                track_name = target_file.sub(
                    /\.json$/, '',
                )

                new_action = ChtrackUtils::PromptAction.execute(
                    "#{Color.N}#{track_name}#{Color.DG}::#{Color.N}Name",
                    data["Track"] || track_name,
                )

                if new_action.downcase == "mpfly::remove"
                    FileUtils.rm(file_path)
                    printf(
                        "%s[-] %sFile: %s%s %sremoved.\n",
                        Color.YY, Color.N, Color.GG, target_file, Color.N,
                    )
                    next
                end

                data["Track"] = new_action unless
                    new_action.empty? ||
                    new_action.downcase == "mpfly::return"

                data["PlayWith"] = ChtrackUtils::EditPlaywith.execute(
                    data["Track"],
                    data["PlayWith"] || [],
                )

                new_filename = ChtrackUtils::PromptAction.execute(
                    "#{Color.N}#{track_name}#{Color.DG}::#{Color.N}Filename",
                    track_name,
                )

                if !new_filename.empty? &&
                    new_filename != track_name &&
                    new_filename.downcase != "mpfly::return"
                        new_file_path = File.join(
                            dir,
                            "#{new_filename}.json",
                        )

                        if File.exist?(new_file_path)
                            printf(
                                "%s[!] %sFile: %s%s.json %salready exists!\n",
                                Color.YY, Color.N, Color.GG, new_filename, Color.N,
                            )

                            printf(
                                "%s[!] %sSaving to original file.\n",
                                Color.YY, Color.N,
                            )

                            new_file_path = file_path
                        else
                            FileUtils.rm(file_path)
                            file_path = new_file_path
                        end
                end

                File.open(file_path, "w") {
                    |f| f.puts(
                        JSON.pretty_generate(data),
                    )
                }

                printf(
                    "%s[+] %sUpdated: %s%s%s\n",
                    Color.GG, Color.N, Color.GG, file_path, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec