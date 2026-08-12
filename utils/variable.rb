# https://github.com/Zeronetsec/Mpfly

module Variable
    def Prefix
        env_prefix = ENV['PREFIX']
        (
            env_prefix.nil? ||
            env_prefix.empty?
        ) ? "/usr" : env_prefix
    end

    def MPVConf = "#{ENV['HOME']}/.config/mpv/mpv.conf".freeze
    def SCConf = "#{ENV['HOME']}/.config/mpv/input.conf".freeze
    def MpTrack = "#{ENV['HOME']}/.mpfly/mptrack.lst".freeze
    def MpHistory = "#{ENV['HOME']}/.mpfly/history.lst".freeze

    module_function(
        :Prefix,
        :MPVConf,
        :SCConf,
        :MpTrack,
        :MpHistory,
    )
end

# Copyright (c) 2026 Zeronetsec