# utils/write_history.rb

require 'fileutils'
require 'utils/variable'

module WriteHistory
    def self.execute(playlist, song, playwith)
        history_file = Variable.MpHistory

        dir_path = File.dirname(history_file)
        unless File.directory?(dir_path)
            FileUtils.mkdir_p(dir_path)
        end

        now = Time.now
        date_str = now.strftime("%Y-%m-%d")
        time_str = now.strftime("%H:%M:%S")

        playlist_str = (playlist.nil? ||
            playlist.empty?) ?
            "none" :
            playlist

        playwith_str = playwith.is_a?(Array) ?
            playwith.join("::") :
            playwith.to_s

        history_line = "#{date_str}::#{time_str}::#{playlist_str}::#{song}::playwith=#{playwith_str}"

        File.open(history_file, "a") do |f|
            f.puts(history_line)
        end
    end
end

# Copyright (c) 2026 Zeronetsec