# https://github.com/Zeronetsec/Mpfly

require 'utils/color'

module ChtrackUtils
    module PromptAction
        def self.execute(label, old_val = nil)
            loop do
                if old_val
                    printf(
                        "%s-> %s%s: %s%s %s-> %s",
                        Color.CC, Color.N, label,
                        Color.GG, old_val,
                        Color.CC, Color.GG,
                    )
                else
                    printf(
                        "%s-> %s%s:%s ",
                        Color.CC, Color.N, label, Color.GG,
                    )
                end

                input = $stdin.gets.to_s.strip
                return input if
                    input.empty? &&
                    old_val

                return input unless
                    input.empty?
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec