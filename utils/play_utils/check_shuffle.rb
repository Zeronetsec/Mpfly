# https://github.com/Zeronetsec/Mpfly

require 'utils/variable'

module PlayUtils
    module CheckShuffle
        def self.execute()
            conf_path = Variable.MPVConf
            return false unless
                File.exist?(conf_path)

            File.foreach(conf_path) do |line|
                return true if
                    line.strip.downcase == "shuffle=yes"
            end

            false
        end
    end
end

# Copyright (c) 2026 Zeronetsec