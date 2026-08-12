# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'fileutils'
require 'utils/color'

module ConvertUtils
    module WriteFolder
        def self.execute(data, out_dir, input_target)
            FileUtils.mkdir_p(out_dir)
            init_data = {
                "Playlist" => data["Playlist"],
            }

            File.open(
                File.join(
                    out_dir,
                    "__playinit__.json",
                ),
                "w",
            ) do |f|
                f.puts(
                    JSON.pretty_generate(init_data),
                )
            end

            used_names = {}
            success_count = 0

            data["Tracks"].each_with_index do |item, index|
                track_name = item["Track"] ||
                    "unknown_track_#{index}"

                safe_name = track_name.downcase.gsub(
                    /[^a-z0-9]+/, '_',
                ).gsub(/^_|_$/, '')

                safe_name = "track_#{index}" if
                    safe_name.empty?

                if used_names[safe_name]
                    used_names[safe_name] += 1
                    final_name = "#{safe_name}_#{used_names[safe_name]}"
                else
                    used_names[safe_name] = 0
                    final_name = safe_name
                end

                file_path = File.join(
                    out_dir,
                    "#{final_name}.json",
                )

                File.open(file_path, "w") do |f|
                    f.puts(
                        JSON.pretty_generate(item),
                    )
                end
                success_count += 1
            end

            printf(
                "%s[*] %sConvert: %s%s%s\n",
                Color.B, Color.N, Color.GG, input_target, Color.N,
            )

            printf(
                "%s[+] %sExtracted to folder: %s%s %s(%s%d %stracks%s)%s\n",
                Color.GG, Color.N, Color.GG, out_dir, Color.DG,
                Color.CC, success_count, Color.WW, Color.DG,
                Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec