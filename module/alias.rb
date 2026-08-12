# https://github.com/Zeronetsec/Mpfly

require 'utils/invalid_option'
require 'utils/alias_utils/list_aliases'
require 'utils/alias_utils/add_alias'
require 'utils/alias_utils/remove_alias'
require 'utils/alias_utils/change_value'
require 'utils/alias_utils/change_name'

module Alias
    def self.execute(*args)
        args = args.flatten
        args.shift

        if args.empty?
            AliasUtils::ListAliases.execute()
            return
        end

        flag = args.shift
        name = args.shift
        value = args.join(" ").strip

        case flag
            when "--add"
                AliasUtils::AddAlias.execute(name, value)
            when "--remove"
                AliasUtils::RemoveAlias.execute(name)
            when "--chval"
                AliasUtils::ChangeValue.execute(name, value)
            when "--chname"
                AliasUtils::ChangeName.execute(name, value)
            else
                invopt = "--alias " + flag
                InvalidOption.execute(invopt)
        end
    end
end

# Copyright (c) 2026 Zeronetsec