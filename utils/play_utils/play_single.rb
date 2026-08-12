# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/write_history'
require 'utils/play_utils/play_direct'

module PlayUtils
    module PlaySingle
        def self.execute(target)
            printf(
                "%s[*] %sPlaying single track...\n",
                Color.B, Color.N,
            )

            printf(
                "%s[*] %sPlaying: %s%s%s\n",
                Color.B, Color.N, Color.GG, target, Color.N,
            )

            WriteHistory.execute(
                nil,
                target,
                [target],
            )

            PlayUtils::PlayDirect.execute(target)
        end
    end
end

# Copyright (c) 2026 Zeronetsec