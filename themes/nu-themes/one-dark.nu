# Retrieve the theme settings
export def main [] {
    return {
        separator: '#abb2bf'
        leading_trailing_space_bg: { attr: 'n' }
        header: { fg: '#98c379' attr: 'b' }
        empty: '#61afef'
        bool: {|| if $in { '#56b6c2' } else { 'light_gray' } }
        int: '#abb2bf'
        filesize: {|e|
            if $e == 0b {
                '#abb2bf'
            } else if $e < 1mb {
                '#56b6c2'
            } else {{ fg: '#61afef' }}
        }
        duration: '#abb2bf'
        date: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#e06c75' attr: 'b' }
            } else if $in < 6hr {
                '#e06c75'
            } else if $in < 1day {
                '#d19a66'
            } else if $in < 3day {
                '#98c379'
            } else if $in < 1wk {
                { fg: '#98c379' attr: 'b' }
            } else if $in < 6wk {
                '#56b6c2'
            } else if $in < 52wk {
                '#61afef'
            } else { 'dark_gray' }
        }
        range: '#abb2bf'
        float: '#abb2bf'
        string: '#abb2bf'
        nothing: '#abb2bf'
        binary: '#abb2bf'
        cell-path: '#abb2bf'
        row_index: { fg: '#98c379' attr: 'b' }
        record: '#abb2bf'
        list: '#abb2bf'
        block: '#abb2bf'
        hints: 'dark_gray'
        search_result: { fg: '#e06c75' bg: '#abb2bf' }

        shape_and: { fg: '#c678dd' attr: 'b' }
        shape_binary: { fg: '#c678dd' attr: 'b' }
        shape_block: { fg: '#61afef' attr: 'b' }
        shape_bool: '#56b6c2'
        shape_custom: '#98c379'
        shape_datetime: { fg: '#56b6c2' attr: 'b' }
        shape_directory: '#56b6c2'
        shape_external: '#56b6c2'
        shape_externalarg: { fg: '#98c379' attr: 'b' }
        shape_filepath: '#56b6c2'
        shape_flag: { fg: '#61afef' attr: 'b' }
        shape_float: { fg: '#c678dd' attr: 'b' }
        shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
        shape_globpattern: { fg: '#56b6c2' attr: 'b' }
        shape_int: { fg: '#c678dd' attr: 'b' }
        shape_internalcall: { fg: '#56b6c2' attr: 'b' }
        shape_list: { fg: '#56b6c2' attr: 'b' }
        shape_literal: '#61afef'
        shape_match_pattern: '#98c379'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#56b6c2'
        shape_operator: '#d19a66'
        shape_or: { fg: '#c678dd' attr: 'b' }
        shape_pipe: { fg: '#c678dd' attr: 'b' }
        shape_range: { fg: '#d19a66' attr: 'b' }
        shape_record: { fg: '#56b6c2' attr: 'b' }
        shape_redirection: { fg: '#c678dd' attr: 'b' }
        shape_signature: { fg: '#98c379' attr: 'b' }
        shape_string: '#98c379'
        shape_string_interpolation: { fg: '#56b6c2' attr: 'b' }
        shape_table: { fg: '#61afef' attr: 'b' }
        shape_variable: '#c678dd'

        background: '#1e2127'
        foreground: '#5c6370'
        cursor: '#5c6370'
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