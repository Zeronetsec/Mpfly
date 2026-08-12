# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'fileutils'
require 'utils/color'
require 'utils/variable'
require 'module/play'

module SearchUtils
    module DoPlay
        def self.execute(tracks, keyword)
            base_dir = File.join(
                Variable.Prefix,
                "tmp",
                "mpfly",
            )

            FileUtils.mkdir_p(base_dir) unless
                File.directory?(base_dir)

            temp_file = File.join(
                base_dir,
                "temporary_playlist.json",
            )

            temp_data = {
                "Playlist" => "Search Result: '#{keyword}'",
                "Tracks" => tracks,
            }

            File.open(temp_file, "w") do |f|
                f.puts(
                    JSON.pretty_generate(temp_data),
                )
            end

            at_exit do
                FileUtils.rm_f(temp_file) if
                    File.exist?(temp_file)
            end

            printf(
                "%s[*] %sSending: %s%d %stracks to play module...\n",
                Color.B, Color.N, Color.GG, tracks.size, Color.N,
            )

            Play.execute(
                "--play",
                temp_file,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec