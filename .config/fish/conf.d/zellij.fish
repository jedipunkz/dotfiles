# Zellij: auto-rename tab to current directory
function __zellij_tab_rename --on-variable PWD
    if set -q ZELLIJ
        zellij action rename-tab (basename $PWD)
    end
end

# Set tab name on shell startup
if set -q ZELLIJ
    zellij action rename-tab (basename $PWD)
end
