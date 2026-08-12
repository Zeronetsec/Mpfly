# https://github.com/Zeronetsec/Mpfly

require 'shellwords'
require 'utils/color'

module DownloadUtils
    module Compress
        def self.execute(out_dir, mode)
            printf(
                "\n%s[*] %sStarting compression phase...\n",
                Color.B, Color.N,
            )
            
            audio_exts = %w[*.mp3 *.wav *.flac *.m4a *.aac *.ogg *.webm *.opus]
            search_pattern = File.join(
                out_dir,
                "{#{audio_exts.join(',')}}",
            )
            files = Dir.glob(search_pattern)

            if files.empty?
                printf(
                    "%s[!] %sNo audio files found for compression!\n",
                    Color.YY, Color.N,
                )
                return
            end

            files.each do |file|
                next unless File.exist?(file)
                
                dir = File.dirname(file)
                ext = File.extname(file)
                base = File.basename(file, ext)

                tmp_file = File.join(
                    dir,
                    "temp_#{base}.mp3",
                )

                final_file = File.join(
                    dir,
                    "#{base}.mp3",
                )

                printf(
                    "    %s├── %scompressing: %s%s%s\n",
                    Color.DG, Color.WW, Color.GG, File.basename(file), Color.N,
                )

                if mode.downcase == "auto"
                    cmd = "ffmpeg -y -i #{Shellwords.escape(file)} -c:a libmp3lame -q:a 3 #{Shellwords.escape(tmp_file)} -hide_banner -loglevel error"
                else
                    custom_args = mode.dup
                    custom_args.gsub!(
                        "file.mp3",
                        Shellwords.escape(file),
                    )

                    custom_args.gsub!(
                        "out.mp3",
                        Shellwords.escape(tmp_file),
                    )

                    custom_args.gsub!(
                        "{in}",
                        Shellwords.escape(file),
                    )

                    custom_args.gsub!(
                        "{out}",
                        Shellwords.escape(tmp_file),
                    )
                    
                    cmd = custom_args.start_with?("ffmpeg") ?
                        custom_args :
                        "ffmpeg #{custom_args}"
                end

                system(cmd)
                if $?.success?
                    File.delete(file) if file != tmp_file &&
                        File.exist?(file)

                    File.rename(
                        tmp_file,
                        final_file,
                    ) if File.exist?(tmp_file)

                    printf(
                        "    %s│   └── %sdone %s-> %s%s%s\n",
                        Color.DG, Color.GG, Color.DG,
                        Color.CC, File.basename(final_file), Color.N,
                    )
                else
                    printf(
                        "    %s│   └── %sfailed\n",
                        Color.DG, Color.R,
                    )

                    File.delete(tmp_file) if
                        File.exist?(tmp_file)
                end
            end
            printf(
                "%s[+] %sCompression finished.\n",
                Color.GG, Color.N,
            )
        end
    end
end

# Copyright (c) 2026 Zeronetsec