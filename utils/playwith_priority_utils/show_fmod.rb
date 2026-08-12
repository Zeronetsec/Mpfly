# https://github.com/Zeronetsec/Mpfly

require 'json'
require 'utils/color'
require 'utils/playwith_priority_utils/render_show'

module PlaywithPriorityUtils
    module ShowFmod
        def self.execute(dir)
            init_file = File.join(
                dir,
                "__playinit__.json",
            )

            playlist_name = File.exist?(init_file) ?
                JSON.parse(
                    File.read(init_file),
                )["Playlist"] : File.basename(dir)

            printf(
                "%s[*] %sPlaylist: %s%s%s\n",
                Color.B, Color.N, Color.GG, playlist_name, Color.N,
            )

            Dir.glob(
                File.join(dir, "*.json"),
            ).reject {
                    |f| File.basename(f) == "__playinit__.json"
            }.sort.each do |f|
                data = JSON.parse(File.read(f))
                PlaywithPriorityUtils::RenderShow.execute(
                    data["Track"],
                    data["PlayWith"],
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec