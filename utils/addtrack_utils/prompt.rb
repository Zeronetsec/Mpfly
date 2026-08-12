# https://github.com/Zeronetsec/Mpfly

module AddtrackUtils
    module Prompt
        def self.execute(message)
            loop do
                printf(
                    "%s",
                    message,
                )
                input = $stdin.gets.to_s.strip
                return input unless input.empty?
            end
        end
    end
end

# Copyright (c) 2026 Zeronetsec