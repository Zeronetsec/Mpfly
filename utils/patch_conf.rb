# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/variable'

module PatchConf
    def self.execute(action)
        unless defined?(Variable) &&
               Variable.respond_to?(:MPVConf)
            printf(
                "%s[!] %sVariable: %sVariable.MPVConf %scannot be accessed!\n",
                Color.R, Color.N, Color.GG, color.N,
            )
            return
        end

        conf_path = Variable.MPVConf
        if conf_path.nil? || conf_path.empty?
            printf(
                "%s[!] %sVariable: %sVariable.MPVConf %sis empty!\n",
                Color.R, Color.N, Color.GG, Color.N,
            )
            return
        end

        unless File.exist?(conf_path)
            printf(
                "%s[!] %sFile: %s#{conf_path} %sconfig not found!\n",
                Color.R, Color.N, Color.GG, Color.N,
            )
            return
        end

        file_content = File.read(conf_path)
        is_modified = false

        case action.to_s.downcase
        when "patch"
            if file_content.match?(
                /^(\s*)loop-playlist=(.*)$/,
            )
                file_content = file_content.gsub(
                    /^(\s*)loop-playlist=(.*)$/,
                    '\1#loop-playlist=\2',
                )

                printf(
                    "%s[*] %sPatch: %s#loop-playlist %s-> %s%s%s\n",
                    Color.B, Color.N, Color.GG, Color.DG,
                    Color.GG, Variable.MPVConf, Color.N,
                )

                is_modified = true
            end

        when "unpatch"
            if file_content.match?(
                /^(\s*)#+\s*(loop-playlist=.*)$/,
            )
                file_content = file_content.gsub(
                    /^(\s*)#+\s*(loop-playlist=.*)$/,
                    '\1\2',
                )

                printf(
                    "%s[*] %sUnpatch: %s#loop-playlist %s-> %s%s%s\n",
                    Color.B, Color.N, Color.GG, Color.DG,
                    Color.GG, Variable.MPVConf, Color.N,
                )

                is_modified = true
            end

        else
            printf(
                "%s[!] %sInvalid action: %s%s%s\n",
                Color.R, Color.N, Color.GG, action, Color.N,
            )
            return
        end

        if is_modified
            File.write(
                conf_path,
                file_content,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec