# this module regroups a bunch of development tools to make the development
# process easier for anyone.
#
# the main purpose of `toolkit` is to offer an easy to use interface for the
# developer during a PR cycle.


# check that all the tests pass
export def test [
] {
    print "toolkit test: not implemented!"
}

# formats the pipe input inside backticks, dimmed and italic, as a pretty command
def pretty-format-command [] {
    $"`(ansi default_dimmed)(ansi default_italic)($in)(ansi reset)`"
}

# run all the necessary checks and tests to submit a perfect PR
export def "check pr" [
] {
    generate-file-list
    test
}

def windows? [] {
    $nu.os-info.name == windows
}

export def main [] { help toolkit }

export def generate-file-list [] {
    let start = "let files = ["
    let files  = glob **/*.nu --exclude [before_v0.60/**]

    let new_list = $files | str join ",\n" | append "]"

    let final = "
    for file in $files {
        # print $\"checking ($file)\"
        let result = nu-check $file
        if $result {
            # print $\"✔ ($file) is ok\"
        } else {
            print $\"❌ ($file) is wrong!\"
        }
    }"


    $start 
    | append $new_list
    | append $final 
    | save "check-files.nu" --force
}