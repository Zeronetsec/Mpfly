# https://github.com/Zeronetsec/Mpfly

require 'utils/color'
require 'utils/invalid_option'
require 'utils/history_utils/clear_history'
require 'utils/history_utils/show_summary'
require 'utils/history_utils/show_details'

module History
    def self.execute(*args)
        args = args.flatten
        args.shift

        if args.empty?
            HistoryUtils::ShowDetails.execute()
            printf("\n")
            HistoryUtils::ShowSummary.execute()
            return
        end

        flag = args.shift
        case flag
            when "--clear"
                HistoryUtils::ClearHistory.execute()
            when "--summary-only"
                HistoryUtils::ShowSummary.execute()
            else
                invopt = "--history " + flag
                InvalidOption.execute(invopt)
        end
    end
end

# Copyright (c) 2026 Zeronetsec