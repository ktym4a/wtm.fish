# Completions for wtm - Git worktree manager

# Disable file completions for wtm
complete -c wtm -f

# Global options
complete -c wtm -s h -l help -d "Show help message"
complete -c wtm -s v -l verbose -d "Enable verbose output"
complete -c wtm -s q -l quiet -d "Suppress informational output"

# Subcommands
complete -c wtm -n "__fish_use_subcommand" -a add -d "Create new branch and worktree"
complete -c wtm -n "__fish_use_subcommand" -a remove -d "Remove worktree and branch"
complete -c wtm -n "__fish_use_subcommand" -a rm -d "Remove worktree and branch"
complete -c wtm -n "__fish_use_subcommand" -a list -d "List all worktrees"
complete -c wtm -n "__fish_use_subcommand" -a ls -d "List all worktrees"
complete -c wtm -n "__fish_use_subcommand" -a clean -d "Clean up stale worktrees"
complete -c wtm -n "__fish_use_subcommand" -a init -d "Create .wt_hook.fish template"
complete -c wtm -n "__fish_use_subcommand" -a main -d "Switch to default branch (main/master)"
complete -c wtm -n "__fish_use_subcommand" -a help -d "Show help message"

# Options for 'add' subcommand
complete -c wtm -n "__fish_seen_subcommand_from add" -s b -l base -xa "(git branch --format='%(refname:short)')" -d "Base branch (default: main)"
complete -c wtm -n "__fish_seen_subcommand_from add" -l sync -d "Sync staged/modified/untracked files"
complete -c wtm -n "__fish_seen_subcommand_from add" -l no-hook -d "Skip hook execution"
complete -c wtm -n "__fish_seen_subcommand_from add" -s h -l help -d "Show help for add command"

# Options for 'remove' subcommand
# Complete with branch names from worktrees (excluding main/master and current branch)
complete -c wtm -n "__fish_seen_subcommand_from remove rm" -xa "(__wtm_git_worktree_branches)"
complete -c wtm -n "__fish_seen_subcommand_from remove rm" -s h -l help -d "Show help for remove command"

# Options for 'list' subcommand
complete -c wtm -n "__fish_seen_subcommand_from list ls" -s h -l help -d "Show help for list command"

# Options for 'clean' subcommand
complete -c wtm -n "__fish_seen_subcommand_from clean" -s n -l dry-run -d "Show what would be removed"
complete -c wtm -n "__fish_seen_subcommand_from clean" -l days -x -d "Remove worktrees older than n days"
complete -c wtm -n "__fish_seen_subcommand_from clean" -s h -l help -d "Show help for clean command"

# Helper function to get worktree branches (excluding main/master)
function __wtm_git_worktree_branches --description "Get worktree branches for completion"
    # Get current branch to exclude it
    set -l current_branch (git branch --show-current 2>/dev/null)

    # Get all worktree branches
    git worktree list 2>/dev/null | while read -l line
        set -l branch (echo $line | string match -r '\[([^\]]+)\]' | string split -f2 '[' | string trim -c ']')
        # Exclude main, master, and current branch
        if test -n "$branch"
            and not string match -qr '^(main|master)$' "$branch"
            and test "$branch" != "$current_branch"
            echo $branch
        end
    end
end
