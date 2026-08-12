# https://github.com/Zeronetsec/Mpfly

module MptrackAlias
    def self.execute(file_path, alias_name)
        return nil unless File.exist?(file_path)

        File.foreach(file_path) do |line|
            line = line.strip
            next if line.empty? || line.start_with?("#")

            if line.include?("->")
                parts = line.split("->", 2)
                current_alias = parts[0].strip
                path = parts[1].strip

                if current_alias == alias_name
                    path = path.sub(
                        /^['"]/, '',
                    ).sub(/['"]$/, '')
                    return path
                end
            end
        end
        nil
    end
end

# Copyright (c) 2026 Zeronetsec