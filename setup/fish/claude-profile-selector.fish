# Claude Profile Selector - runs on new terminal
if status is-interactive
    if not set -q CLAUDE_CONFIG_DIR
        # Check if claude exists (don't rely on PATH being set yet)
        if test -e ~/.local/bin/claude; or type -q claude
            echo ""
            set_color brblue
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "  Claude Profile Selection"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            set_color normal
            echo ""
            echo "  [w] Work"
            echo "  [p] Personal"
            echo "  [s] Skip (use default ~/.claude)"
            echo ""
            read -P "  Select profile: " -n 1 choice

            switch $choice
                case w W
                    set -gx CLAUDE_CONFIG_DIR "$HOME/.claude-profiles/work"
                    set_color green
                    echo "  ✓ Work profile activated"
                    set_color normal
                case p P
                    set -gx CLAUDE_CONFIG_DIR "$HOME/.claude-profiles/personal"
                    set_color green
                    echo "  ✓ Personal profile activated"
                    set_color normal
                case s S ''
                    set_color yellow
                    echo "  → Using default (~/.claude)"
                    set_color normal
                case '*'
                    set_color yellow
                    echo "  → Invalid choice, using default"
                    set_color normal
            end
            echo ""
        end
    end
end
