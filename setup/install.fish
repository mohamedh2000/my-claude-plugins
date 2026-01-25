#!/usr/bin/env fish
# Claude Profile & Plugin Setup Script
# Run: fish ~/my-claude-plugins/setup/install.fish
#
# This script sets up:
# - Claude profiles (work/personal)
# - Profile symlinks to shared resources
# - Fish profile selector
# - Continuous learning system
# - Plugin marketplace symlink

set -l SCRIPT_DIR (dirname (status -f))
set -l REPO_DIR (dirname $SCRIPT_DIR)

echo ""
set_color brblue
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Claude Profile & Plugin Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
set_color normal
echo ""

# Check if claude is installed
if not test -e ~/.local/bin/claude; and not type -q claude
    set_color red
    echo "✗ Claude CLI not found. Please install it first:"
    echo "  https://docs.anthropic.com/en/docs/claude-code"
    set_color normal
    exit 1
end

echo "Found claude at:" (which claude 2>/dev/null; or echo ~/.local/bin/claude)
echo ""

# ─────────────────────────────────────────────────────────────
# Step 1: Create base directories
# ─────────────────────────────────────────────────────────────
echo "Step 1: Creating directory structure..."

mkdir -p ~/.claude
mkdir -p ~/.claude/skills/learned
mkdir -p ~/.claude/hooks
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/agents
mkdir -p ~/.claude/plugins/marketplaces

mkdir -p ~/.claude-profiles/work/skills/learned
mkdir -p ~/.claude-profiles/work/projects
mkdir -p ~/.claude-profiles/personal/skills/learned
mkdir -p ~/.claude-profiles/personal/projects

set_color green
echo "  ✓ Directories created"
set_color normal

# ─────────────────────────────────────────────────────────────
# Step 2: Create symlinks for shared resources in profiles
# ─────────────────────────────────────────────────────────────
echo ""
echo "Step 2: Setting up profile symlinks..."

# Function to create symlink if it doesn't exist
function create_symlink
    set -l source $argv[1]
    set -l target $argv[2]

    if test -L $target
        rm $target
    end

    if test -e $source
        ln -sf $source $target
        echo "    Linked: $target -> $source"
    else
        echo "    Skipped (source doesn't exist): $source"
    end
end

# Shared resources to symlink into each profile
set -l shared_resources CLAUDE.md settings.json settings.local.json commands hooks agents plugins

for profile in work personal
    set -l profile_dir ~/.claude-profiles/$profile

    for resource in $shared_resources
        if test -e ~/.claude/$resource
            create_symlink ~/.claude/$resource $profile_dir/$resource
        end
    end

    # Symlink all skills EXCEPT learned (which is profile-specific)
    for skill in ~/.claude/skills/*/
        set -l skill_name (basename $skill)
        if test "$skill_name" != "learned"
            create_symlink $skill $profile_dir/skills/$skill_name
        end
    end
end

set_color green
echo "  ✓ Profile symlinks created"
set_color normal

# ─────────────────────────────────────────────────────────────
# Step 3: Set up plugin marketplace symlink
# ─────────────────────────────────────────────────────────────
echo ""
echo "Step 3: Setting up plugin marketplace..."

if test -d $REPO_DIR
    # Use the repo folder name as the marketplace name
    set -l marketplace_name (basename $REPO_DIR)
    create_symlink $REPO_DIR ~/.claude/plugins/marketplaces/$marketplace_name
    set_color green
    echo "  ✓ Plugin marketplace linked as: $marketplace_name"
    set_color normal
else
    set_color yellow
    echo "  ⚠ Repository directory not found: $REPO_DIR"
    set_color normal
end

# ─────────────────────────────────────────────────────────────
# Step 4: Install fish profile selector
# ─────────────────────────────────────────────────────────────
echo ""
echo "Step 4: Installing fish profile selector..."

mkdir -p ~/.config/fish/conf.d
mkdir -p ~/.config/fish/functions

# Install conf.d script
cp $SCRIPT_DIR/fish/claude-profile-selector.fish ~/.config/fish/conf.d/

# Install claude-profile function
cp $SCRIPT_DIR/fish/claude-profile.fish ~/.config/fish/functions/

set_color green
echo "  ✓ Fish profile selector installed"
set_color normal

# ─────────────────────────────────────────────────────────────
# Step 5: Install continuous learning system (symlink to repo)
# ─────────────────────────────────────────────────────────────
echo ""
echo "Step 5: Installing continuous learning system..."

# Symlink skills from the repo (not copies)
create_symlink $REPO_DIR/skills/continuous-learning ~/.claude/skills/continuous-learning
create_symlink $REPO_DIR/skills/learn ~/.claude/skills/learn

# Make scripts executable
chmod +x $REPO_DIR/skills/continuous-learning/*.sh 2>/dev/null

set_color green
echo "  ✓ Continuous learning installed (symlinked to repo)"
set_color normal

# ─────────────────────────────────────────────────────────────
# Step 6: Update settings.json with hooks
# ─────────────────────────────────────────────────────────────
echo ""
echo "Step 6: Checking settings.json hooks..."

if test -f ~/.claude/settings.json
    # Check if hooks already exist
    if grep -q "continuous-learning" ~/.claude/settings.json
        set_color green
        echo "  ✓ Hooks already configured"
        set_color normal
    else
        set_color yellow
        echo "  ⚠ Please manually add hooks to ~/.claude/settings.json"
        echo "    See: $SCRIPT_DIR/settings-hooks-example.json"
        set_color normal
    end
else
    # Create default settings.json
    cp $SCRIPT_DIR/settings-template.json ~/.claude/settings.json
    set_color green
    echo "  ✓ Default settings.json created"
    set_color normal
end

# ─────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────
echo ""
set_color brblue
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
set_color normal
echo ""
echo "Next steps:"
echo ""
echo "  1. Open a new terminal - you'll see the profile selector"
echo ""
echo "  2. Log into each profile:"
set_color cyan
echo "     # For work:"
echo "     claude-profile work"
echo "     claude login"
echo ""
echo "     # For personal:"
echo "     claude-profile personal"
echo "     claude login"
set_color normal
echo ""
echo "  3. If using iTerm2, set Command to:"
set_color cyan
echo "     /opt/homebrew/bin/fish  (Apple Silicon)"
echo "     /usr/local/bin/fish     (Intel)"
set_color normal
echo ""
echo "Profile locations:"
echo "  Work:     ~/.claude-profiles/work/"
echo "  Personal: ~/.claude-profiles/personal/"
echo "  Default:  ~/.claude/"
echo ""
