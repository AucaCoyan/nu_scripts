# this completions are based upon the cheatsheet guidelines

# Google Cloud Platform `gcloud` command
export extern "gcloud" [
    --access-token-file: path               # A file path to read the access token.
    --account: string                       # Google Cloud user account to use for invocation
    --billing-project: string               # The Google Cloud project that will be charged quota for operations performed in gcloud
    --configuration: string                 # The configuration to use for this command invocation. For more information on how to use configurations, run: gcloud topic configurations
    --flags-file: path                      # A YAML or JSON file that specifies a --flag:value dictionary
    --flatten: string                       # Flatten `name[]` output resource slices in KEY into separate records for each item in each slice
    --format: string@"nu-complete formats"  # Sets the format for printing command output resources. For more details run $ gcloud topic formats
    --help                                  # Display detailed help
    --impersonate-service-account: string   # For this invocation, all API requests will be made as the given account instead of the currently selected account
    --log-http                              # Log all HTTP server requests and responses to stderr
    --project: string                       # The Google Cloud project ID to use for this invocation
    --quiet                                 # Disable all interactive prompts when running gcloud commands
    --trace-token: string                   # Token used to route traces of service requests for investigation of issues
    --verbosity: string@"nu-complete verbosity" # Override the default verbosity for this command. Default is warning
    topic?:string@"nu-complete topics"      # gcloud supplementary help
    ...args: any
]

def "nu-complete topics" [] {
    ^gcloud topic
    | lines 
    | filter { str starts-with "   " } 
    | skip 1 
    | parse "{value}: {description}" 
    | str trim
}

def myfunc [] {
  ^gcloud topic --help | to text | str replace --regex --multiline --all '(NAME[\s\S]*(?=TOPICS))' '' | lines | skip 2 | filter { str starts-with "     " }
  ^gcloud topic --help | lines | str replace --regex --multiline '\S+\K.*' ''
    ^gcloud topic --help | lines | filter { str starts-with "     " }
     | skip 1 | parse "{value}: {description}" | str trim
}

def "nu-complete components" [] {
    gcloud components list | lines | skip 5 | drop 1 | parse "|{status}|{description}|{value}|{version}|" | select value description
}

export extern "gcloud components install" [
    component: string@"nu-complete components"
]

# GCP alpha commands
export extern "gcloud alpha" [...args]

# GCP beta commands
export extern "gcloud beta" [...args]

def "nu-complete verbosity" [] {
    ['debug', 'info', 'warning', 'error', 'critical', 'none']
}

def "nu-complete formats" [] {
    ['config', 'csv', 'default', 'diff', 'disable', 'flattened', 'get', 'json', 'list', 'multi', 'none', 'object', 'table', 'text', 'value', 'yaml' ]
}

