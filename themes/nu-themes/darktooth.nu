# Retrieve the theme settings
export def main [] {
    return {
        separator: '#a89984'
        leading_trailing_space_bg: { attr: 'n' }
        header: { fg: '#95c085' attr: 'b' }
        empty: '#0d6678'
        bool: {|| if $in { '#8ba59b' } else { 'light_gray' } }
        int: '#a89984'
        filesize: {|e|
            if $e == 0b {
                '#a89984'
            } else if $e < 1mb {
                '#8ba59b'
            } else {{ fg: '#0d6678' }}
        }
        duration: '#a89984'
        date: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#fb543f' attr: 'b' }
            } else if $in < 6hr {
                '#fb543f'
            } else if $in < 1day {
                '#fac03b'
            } else if $in < 3day {
                '#95c085'
            } else if $in < 1wk {
                { fg: '#95c085' attr: 'b' }
            } else if $in < 6wk {
                '#8ba59b'
            } else if $in < 52wk {
                '#0d6678'
            } else { 'dark_gray' }
        }
        range: '#a89984'
        float: '#a89984'
        string: '#a89984'
        nothing: '#a89984'
        binary: '#a89984'
        cellpath: '#a89984'
        row_index: { fg: '#95c085' attr: 'b' }
        record: '#a89984'
        list: '#a89984'
        block: '#a89984'
        hints: 'dark_gray'
        search_result: { fg: '#fb543f' bg: '#a89984' }

        shape_and: { fg: '#8f4673' attr: 'b' }
        shape_binary: { fg: '#8f4673' attr: 'b' }
        shape_block: { fg: '#0d6678' attr: 'b' }
        shape_bool: '#8ba59b'
        shape_custom: '#95c085'
        shape_datetime: { fg: '#8ba59b' attr: 'b' }
        shape_directory: '#8ba59b'
        shape_external: '#8ba59b'
        shape_externalarg: { fg: '#95c085' attr: 'b' }
        shape_filepath: '#8ba59b'
        shape_flag: { fg: '#0d6678' attr: 'b' }
        shape_float: { fg: '#8f4673' attr: 'b' }
        shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
        shape_globpattern: { fg: '#8ba59b' attr: 'b' }
        shape_int: { fg: '#8f4673' attr: 'b' }
        shape_internalcall: { fg: '#8ba59b' attr: 'b' }
        shape_list: { fg: '#8ba59b' attr: 'b' }
        shape_literal: '#0d6678'
        shape_match_pattern: '#95c085'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#8ba59b'
        shape_operator: '#fac03b'
        shape_or: { fg: '#8f4673' attr: 'b' }
        shape_pipe: { fg: '#8f4673' attr: 'b' }
        shape_range: { fg: '#fac03b' attr: 'b' }
        shape_record: { fg: '#8ba59b' attr: 'b' }
        shape_redirection: { fg: '#8f4673' attr: 'b' }
        shape_signature: { fg: '#95c085' attr: 'b' }
        shape_string: '#95c085'
        shape_string_interpolation: { fg: '#8ba59b' attr: 'b' }
        shape_table: { fg: '#0d6678' attr: 'b' }
        shape_variable: '#8f4673'

        background: '#1d2021'
        foreground: '#a89984'
        cursor: '#a89984'
    }
}

# Update the Nushell configuration
export def --env "set color_config" [] {
    $env.config.color_config = (main)
}

# Update terminal colors
export def "update terminal" [] {
    let theme = (main)

    # Set terminal colors
    let osc_screen_foreground_color = '10;'
    let osc_screen_background_color = '11;'
    let osc_cursor_color = '12;'
        
    $"
    (ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)
    (ansi -o $osc_screen_background_color)($theme.background)(char bel)
    (ansi -o $osc_cursor_color)($theme.cursor)(char bel)
    "
    # Line breaks above are just for source readability
    # but create extra whitespace when activating. Collapse
    # to one line
    | str replace --all "\n" ''
    | print $in
}

export module activate {
    export-env {
        set color_config
        update terminal
    }
}

# Activate the theme when sourced
use activate