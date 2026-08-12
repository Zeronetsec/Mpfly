# https://github.com/Zeronetsec/Mpfly

require 'utils/variable'

module HistoryUtils
    module ReadData
        def self.execute()
            history_file = Variable.MpHistory
            return [] unless File.exist?(history_file)
            lines = File.readlines(history_file).reject {
                |l| l.strip.empty?
            }
            
            data = []
            lines.each do |line|
                parts = line.strip.split("::", 5)
                next if parts.size < 5

                playwith_raw = parts[4].sub(
                    "playwith=", "",
                )

                playwith_arr = playwith_raw.split("::")

                data << {
                    date: parts[0],
                    time: parts[1],
                    playlist: parts[2],
                    song: parts[3],
                    playwith: playwith_arr.reject(&:empty?)
                }
            end
            data
        end
    end
end

# Copyright (c) 2026 Zeronetsec