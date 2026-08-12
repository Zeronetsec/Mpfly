# https://github.com/Zeronetsec/Mpfly

require 'date'
require 'utils/color'

module Birthday
    def self.execute(*)
        birth_date = "07-08"
        today = Time.now.strftime("%m-%d")
        if today == birth_date
            printf(
                "%s› %sHappy birthday for %sMpfly %s🎉\n",
                Color.R, Color.N, Color.GG, Color.N,
            )
            printf("\n")
        end
    end
end

# Copyright (c) 2026 Zeronetsec