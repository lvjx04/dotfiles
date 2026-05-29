set -l conda_root "$HOME/Work/anaconda3"

if test -f "$conda_root/bin/conda"
    eval "$conda_root/bin/conda" "shell.fish" "hook" $argv | source
else if test -f "$conda_root/etc/fish/conf.d/conda.fish"
    source "$conda_root/etc/fish/conf.d/conda.fish"
else if test -d "$conda_root/bin"
    set -x PATH "$conda_root/bin" $PATH
end
