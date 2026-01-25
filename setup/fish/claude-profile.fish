function claude-profile
    set -l profile $argv[1]
    if test -z "$profile"
        set profile personal
    end

    if test "$profile" != "work" -a "$profile" != "personal"
        echo "Usage: claude-profile [work|personal]"
        echo ""
        echo "Profiles:"
        echo "  work     - Work account with work-specific learned skills"
        echo "  personal - Personal account with personal learned skills"
        return 1
    end

    set -gx CLAUDE_CONFIG_DIR "$HOME/.claude-profiles/$profile"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Claude profile: $profile"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Config dir:     $CLAUDE_CONFIG_DIR"
    echo "Learned skills: $CLAUDE_CONFIG_DIR/skills/learned/"
    echo ""
    echo "Shared (symlinked):"
    echo "  - CLAUDE.md, settings.json"
    echo "  - commands/, hooks/, plugins/, agents/"
    echo "  - All marketplace skills"
    echo ""
    echo "Run 'claude' to start with this profile."
    echo "Run 'claude login' if this is your first time using this profile."
end
