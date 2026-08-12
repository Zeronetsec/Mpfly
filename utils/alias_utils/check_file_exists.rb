# https://github.com/Zeronetsec/Mpfly

require 'fileutils'
require 'utils/variable'

module AliasUtils
    module CheckFileExists
        def self.execute()
            dir_path = File.dirname(Variable.MpTrack)
            unless File.directory?(dir_path)
                FileUtils.mkdir_p(dir_path)
            end

            unless File.exist?(Variable.MpTrack)
                FileUtils.touch(Variable.MpTrack)
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec