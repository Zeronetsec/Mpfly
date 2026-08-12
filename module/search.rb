# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'
require 'utils/mptrack_alias'
require 'utils/missing_argument'
require 'utils/search_utils/load_json_mode'
require 'utils/search_utils/load_folder_mode'
require 'utils/search_utils/render_tree_list'
require 'utils/search_utils/do_play'

module Search
    def self.execute(*args)
        args = args.flatten
        args.shift

        play_idx = args.index("--play")
        play_mode = nil

        if play_idx
            if play_idx + 1 < args.length
                play_mode = args[play_idx + 1].downcase
                args.delete_at(play_idx + 1)
            end
            args.delete_at(play_idx)
        end

        if args.size < 2
            MissingArgument.execute()
            return
        end

        keyword = args.pop.downcase
        target = args.join(" ").strip

        if target.start_with?("@")
            resolved_target = MptrackAlias.execute(
                Variable.MpTrack,
                target,
            )

            if resolved_target.nil? ||
                resolved_target.empty?
                    printf(
                        "%s[!] %sAlias: %s%s %snot found!\n",
                        Color.R, Color.N, Color.GG, target, Color.N,
                    )
                    return
            end

            printf(
                "%s[*] %sResolved input alias: %s%s %s-> %s%s%s\n",
                Color.B, Color.N, Color.GG, target, Color.DG,
                Color.GG, resolved_target, Color.N,
            )

            target = resolved_target
        end

        all_tracks = target.end_with?(".json") ?
            SearchUtils::LoadJsonMode.execute(target) :
            SearchUtils::LoadFolderMode.execute(target)

        return if all_tracks.nil? || all_tracks.empty?
        found_tracks = all_tracks.select {
                |t| t["Track"].to_s.downcase.include?(keyword)
        }

        if found_tracks.empty?
            printf(
                "%s[!] %sNo tracks found matching keyword: %s%s%s\n",
                Color.R, Color.N, Color.GG, keyword, Color.N,
            )
            return
        end

        if play_mode.nil?
            printf(
                "%s[*] %sFound %s%d %stracks matching %s%s%s:\n",
                Color.B, Color.N, Color.GG, found_tracks.size, Color.N,
                Color.GG, keyword, Color.N,
            )

            SearchUtils::RenderTreeList.execute(
                found_tracks.map {
                    |t| t["Track"]
                },
            )
            
        elsif play_mode == "all"
            SearchUtils::DoPlay.execute(
                found_tracks,
                keyword,
            )

        elsif play_mode == "selection"
            printf(
                "%s[*] %sAvailable track:\n",
                Color.B, Color.N,
            )

            SearchUtils::RenderTreeList.execute(
                found_tracks.map {
                    |t| t["Track"]
                },
            )

            printf(
                "%sHandler:\n",
                Color.N,
            )

            printf(
                "%s- %smpfly::return %s-> %sSelect%s\n",
                Color.DG, Color.GG, Color.DG, Color.GG, Color.N,
            )

            printf(
                "%s-> %sSelect: ",
                Color.CC, Color.N,
            )

            select_input = $stdin.gets.to_s.strip

            return if select_input.empty? ||
                select_input.downcase == "mpfly::return"

            selected_indices = select_input.split(
                ",",
            ).map(&:strip).select {
                |s| s.match?(
                    /^\d+$/,
                )
            }.map(&:to_i)

            selected_tracks = []
            selected_indices.each do |idx|
                if idx > 0 && idx <= found_tracks.size
                    selected_tracks << found_tracks[idx - 1]
                else
                    printf(
                        "%s[!] %sSkipping invalid index: %s%d%s\n",
                        Color.YY, Color.N, Color.GG, idx, Color.N,
                    )
                end
            end

            if selected_tracks.empty?
                printf(
                    "%s[!] %sNo valid tracks selected!\n",
                    Color.R, Color.N,
                )
            else
                SearchUtils::DoPlay.execute(
                    selected_tracks,
                    keyword,
                )
            end
        else
            printf(
                "%s[!] %sUnknown play mode: %s%s%s\n",
                Color.R, Color.N, Color.GG, play_mode, Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec