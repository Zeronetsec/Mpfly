# https://github.com/Zeronetsec/Mpfly

require 'utils/color'

module PlayUtils
    module PlayDirect
        def self.execute(source, track_name = nil)
            name_display = track_name ?
                track_name :
                source

            system("mpv", "--no-video", source)
            if $?.exitstatus == 130
                printf("\n")
                printf(
                    "%s[*] %sInterrupted by user.\n",
                    Color.B, Color.N,
                )
                exit(0)
            end
            $?.success?
        end
    end
end

# Copyright (c) 2026 Zeronetsec