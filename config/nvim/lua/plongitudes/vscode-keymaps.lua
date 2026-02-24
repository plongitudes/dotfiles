-- VSCode Neovim extension keymaps
-- These keymaps use vim.fn.VSCodeNotify() to call VSCode commands from within Neovim
-- They bridge the gap between Neovim keybindings and VSCode functionality

local M = {}

-- Helper function to create VSCode command keymaps
local function vscode_map(mode, lhs, vscode_command, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  opts.desc = opts.desc or ("VSCode: " .. vscode_command)

  vim.keymap.set(mode, lhs, function()
    vim.fn.VSCodeNotify(vscode_command)
  end, opts)
end

-- Helper for commands with arguments
local function vscode_map_with_args(mode, lhs, vscode_command, args, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  opts.desc = opts.desc or ("VSCode: " .. vscode_command)

  vim.keymap.set(mode, lhs, function()
    vim.fn.VSCodeNotifyRange(vscode_command, args[1], args[2], 1)
  end, opts)
end

function M.setup()
  -- Leader key (should match your Neovim config)
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  -- ============================================================================
  -- LSP NAVIGATION (most important, use these constantly)
  -- ============================================================================
  vscode_map('n', 'gd', 'editor.action.revealDefinition', { desc = 'Go to definition' })
  vscode_map('n', 'gD', 'editor.action.revealDeclaration', { desc = 'Go to declaration' })
  vscode_map('n', 'gi', 'editor.action.goToImplementation', { desc = 'Go to implementation' })
  vscode_map('n', 'gr', 'editor.action.goToReferences', { desc = 'Show references' })
  vscode_map('n', 'gT', 'editor.action.goToTypeDefinition', { desc = 'Go to type definition' })
  vscode_map('n', 'K', 'editor.action.showHover', { desc = 'Show hover' })
  vscode_map('n', '<C-k>', 'editor.action.triggerParameterHints', { desc = 'Show signature help' })

  -- ============================================================================
  -- CODE ACTIONS & REFACTORING
  -- ============================================================================
  vscode_map('n', '<leader>ca', 'editor.action.quickFix', { desc = 'Code action' })
  vscode_map('n', '<leader>rn', 'editor.action.rename', { desc = 'Rename symbol' })
  vscode_map('n', '<leader>F', 'editor.action.formatDocument', { desc = 'Format document' })
  vscode_map('v', '<leader>F', 'editor.action.formatSelection', { desc = 'Format selection' })
  -- Organize imports (can be chained with format using multi-command extension)
  vscode_map('n', '<leader>oi', 'editor.action.organizeImports', { desc = 'Organize imports' })

  -- ============================================================================
  -- FILE & PROJECT NAVIGATION
  -- ============================================================================
  vscode_map('n', '<leader><leader>', 'workbench.action.quickOpen', { desc = 'Quick open (smart)' })
  vscode_map('n', '<leader>fc', 'workbench.action.quickOpen', { desc = 'Find files in cwd' })
  vscode_map('n', '<leader>ft', 'workbench.action.quickOpen', { desc = 'Find files (git)' })
  vscode_map('n', '<leader>fr', 'workbench.action.openRecent', { desc = 'Recent files' })
  vscode_map('n', '<leader>fg', 'workbench.action.findInFiles', { desc = 'Search in files (ripgrep)' })
  vscode_map('n', '<leader>b', 'workbench.action.showAllEditors', { desc = 'Show all buffers' })
  vscode_map('n', '<leader>fn', 'notifications.showList', { desc = 'Show notifications' })
  vscode_map('n', '<leader>o', 'outline.focus', { desc = 'Open outline' })

  -- Search for word under cursor
  vim.keymap.set('n', '<leader>fe', function()
    local word = vim.fn.expand('<cword>')
    vim.fn.VSCodeNotify('workbench.action.findInFiles', { query = word })
  end, { desc = 'Search word under cursor' })

  -- ============================================================================
  -- SYMBOLS & WORKSPACE SYMBOLS
  -- ============================================================================
  vscode_map('n', 'gs', 'workbench.action.gotoSymbol', { desc = 'Go to symbol in file' })
  vscode_map('n', 'gS', 'workbench.action.showAllSymbols', { desc = 'Go to symbol in workspace' })

  -- ============================================================================
  -- DIAGNOSTICS
  -- ============================================================================
  vscode_map('n', '<leader>dj', 'editor.action.marker.nextInFiles', { desc = 'Next diagnostic' })
  vscode_map('n', '<leader>dk', 'editor.action.marker.prevInFiles', { desc = 'Previous diagnostic' })
  vscode_map('n', '[d', 'editor.action.marker.prev', { desc = 'Previous diagnostic in file' })
  vscode_map('n', ']d', 'editor.action.marker.next', { desc = 'Next diagnostic in file' })
  vscode_map('n', '<leader>df', 'editor.action.showHover', { desc = 'Show diagnostic (hover)' })
  vscode_map('n', '<leader>dD', 'workbench.actions.view.problems', { desc = 'Show all diagnostics' })
  vscode_map('n', '<leader>dl', 'workbench.action.problems.focus', { desc = 'Focus problems panel' })

  -- ============================================================================
  -- DEBUGGING (DAP)
  -- ============================================================================
  vscode_map('n', '<leader>db', 'editor.debug.action.toggleBreakpoint', { desc = 'Toggle breakpoint' })
  vscode_map('n', '<leader>dB', 'editor.debug.action.conditionalBreakpoint', { desc = 'Conditional breakpoint' })
  vscode_map('n', '<leader>dc', 'workbench.action.debug.continue', { desc = 'Continue/Start debugging' })
  vscode_map('n', '<leader>dt', 'workbench.action.debug.stop', { desc = 'Terminate debugging' })
  vscode_map('n', '<leader>di', 'workbench.action.debug.stepInto', { desc = 'Step into' })
  vscode_map('n', '<leader>do', 'workbench.action.debug.stepOver', { desc = 'Step over' })
  vscode_map('n', '<leader>dO', 'workbench.action.debug.stepOut', { desc = 'Step out' })
  vscode_map('n', '<leader>dr', 'workbench.debug.action.toggleRepl', { desc = 'Toggle REPL' })
  vscode_map('n', '<leader>dl', 'workbench.action.debug.run', { desc = 'Run last debug config' })
  vscode_map('n', '<leader>de', 'editor.debug.action.selectionToWatch', { desc = 'Add to watch' })
  vscode_map('n', '<leader>dp', 'workbench.action.debug.pause', { desc = 'Pause debugging' })

  -- ============================================================================
  -- GIT OPERATIONS
  -- ============================================================================
  vscode_map('n', '<leader>gl', 'workbench.action.editor.nextChange', { desc = 'Next git change' })
  vscode_map('n', '<leader>gh', 'workbench.action.editor.previousChange', { desc = 'Previous git change' })
  vscode_map('n', '<leader>gd', 'git.openChange', { desc = 'Open git diff' })
  vscode_map('n', '<leader>gs', 'git.stageSelectedRanges', { desc = 'Stage hunk' })
  vscode_map('n', '<leader>gr', 'git.revertSelectedRanges', { desc = 'Revert hunk' })
  vscode_map('n', '<leader>gb', 'gitlens.toggleLineBlame', { desc = 'Toggle git blame' })
  -- Alternative git hunk navigation with Alt key
  vscode_map('n', '<M-c>h', 'workbench.action.editor.previousChange', { desc = 'Previous git change' })
  vscode_map('n', '<M-c>l', 'workbench.action.editor.nextChange', { desc = 'Next git change' })

  -- ============================================================================
  -- BUFFER/TAB MANAGEMENT
  -- ============================================================================
  vscode_map('n', '<M-b>h', 'workbench.action.previousEditor', { desc = 'Previous buffer' })
  vscode_map('n', '<M-b>l', 'workbench.action.nextEditor', { desc = 'Next buffer' })
  vscode_map('n', 'gb', 'workbench.action.showAllEditors', { desc = 'Pick buffer' })
  vscode_map('n', '<leader>bc', 'workbench.action.closeActiveEditor', { desc = 'Close buffer' })
  vscode_map('n', '<leader>bd', 'workbench.action.closeActiveEditor', { desc = 'Delete buffer' })
  vscode_map('n', '<leader>bD', 'workbench.action.closeOtherEditors', { desc = 'Delete other buffers' })

  -- ============================================================================
  -- WINDOW/SPLIT NAVIGATION
  -- ============================================================================
  vscode_map('n', '<C-h>', 'workbench.action.navigateLeft', { desc = 'Navigate left' })
  vscode_map('n', '<C-j>', 'workbench.action.navigateDown', { desc = 'Navigate down' })
  vscode_map('n', '<C-k>', 'workbench.action.navigateUp', { desc = 'Navigate up' })
  vscode_map('n', '<C-l>', 'workbench.action.navigateRight', { desc = 'Navigate right' })
  -- Alternative with Alt key (for tmux-like navigation)
  vscode_map('n', '<M-h>', 'workbench.action.navigateLeft', { desc = 'Navigate left' })
  vscode_map('n', '<M-j>', 'workbench.action.navigateDown', { desc = 'Navigate down' })
  vscode_map('n', '<M-k>', 'workbench.action.navigateUp', { desc = 'Navigate up' })
  vscode_map('n', '<M-l>', 'workbench.action.navigateRight', { desc = 'Navigate right' })
  vscode_map('n', '<M-\\>', 'workbench.action.focusLastEditorGroup', { desc = 'Last active pane' })
  vscode_map('n', '<M-Space>', 'workbench.action.focusNextGroup', { desc = 'Next pane' })

  -- ============================================================================
  -- WORKSPACE MANAGEMENT
  -- ============================================================================
  vscode_map('n', '<leader>wa', 'workbench.action.addRootFolder', { desc = 'Add workspace folder' })
  vscode_map('n', '<leader>wr', 'workbench.action.removeRootFolder', { desc = 'Remove workspace folder' })

  -- ============================================================================
  -- TERMINAL
  -- ============================================================================
  vscode_map('n', '<leader>ta', 'workbench.action.terminal.new', { desc = 'New terminal' })
  vscode_map('n', '<leader>tt', 'workbench.action.terminal.toggleTerminal', { desc = 'Toggle terminal' })
  vscode_map('n', '<leader>tk', 'workbench.action.terminal.kill', { desc = 'Kill terminal' })

  -- ============================================================================
  -- FILE EXPLORER
  -- ============================================================================
  vscode_map('n', '<leader>fd', 'workbench.view.explorer', { desc = 'File explorer' })
  vscode_map('n', '<leader>e', 'workbench.action.toggleSidebarVisibility', { desc = 'Toggle sidebar' })

  -- ============================================================================
  -- COMMAND PALETTE & SEARCH
  -- ============================================================================
  vscode_map('n', '<leader>p', 'workbench.action.showCommands', { desc = 'Command palette' })
  vscode_map('n', '<leader>/', 'workbench.action.findInFiles', { desc = 'Search in files' })

  -- ============================================================================
  -- ADDITIONAL USEFUL MAPPINGS
  -- ============================================================================
  vscode_map('n', '<leader>q', 'workbench.action.closeActiveEditor', { desc = 'Close current file' })
  vscode_map('n', '<leader>w', 'workbench.action.files.save', { desc = 'Save file' })
  vscode_map('n', '<leader>W', 'workbench.action.files.saveAll', { desc = 'Save all files' })

  -- Folding
  vscode_map('n', 'za', 'editor.toggleFold', { desc = 'Toggle fold' })
  vscode_map('n', 'zR', 'editor.unfoldAll', { desc = 'Unfold all' })
  vscode_map('n', 'zM', 'editor.foldAll', { desc = 'Fold all' })
  vscode_map('n', 'zo', 'editor.unfold', { desc = 'Open fold' })
  vscode_map('n', 'zc', 'editor.fold', { desc = 'Close fold' })

  -- ============================================================================
  -- VISUAL MODE OPERATIONS
  -- ============================================================================
  vscode_map('v', '<leader>ca', 'editor.action.quickFix', { desc = 'Code action on selection' })
  vscode_map('v', '<leader>r', 'editor.action.startFindReplaceAction', { desc = 'Replace in selection' })

  -- ============================================================================
  -- NEOVIM-SPECIFIC: Keep search centered
  -- ============================================================================
  -- These work within Neovim extension but don't call VSCode commands
  vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
  vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
  vim.keymap.set('n', '*', '*zzzv', { desc = 'Search word under cursor (centered)' })
  vim.keymap.set('n', '#', '#zzzv', { desc = 'Search word backward (centered)' })

  -- ============================================================================
  -- CUSTOM: Special class instantiation search
  -- ============================================================================
  -- This would need a VSCode extension or custom search to replicate the gi functionality
  vim.keymap.set('n', '<leader>fi', function()
    -- Search for class instantiations pattern
    local word = vim.fn.expand('<cword>')
    vim.fn.VSCodeNotify('workbench.action.findInFiles', {
      query = word .. '\\s*\\(',
      isRegex = true
    })
  end, { desc = 'Find class instantiations' })

  print("VSCode keymaps loaded successfully!")
end

-- Auto-setup when module is required
M.setup()

return M