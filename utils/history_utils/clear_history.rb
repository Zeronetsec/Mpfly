# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'

module HistoryUtils
    module ClearHistory
        def self.execute()
            history_file = Variable.MpHistory
            if File.exist?(history_file)
                File.write(history_file, "")
                printf(
                    "%s[+] %sHistory cleared successfully!\n",
                    Color.GG, Color.N,
                )
            else
                printf(
                    "%s[!] %sHistory file is empty or not found!\n",
                    Color.R, Color.N,
                )
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec