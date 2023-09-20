#!/usr/bin/env python

import pdb


class Config(pdb.DefaultConfig):
    # These are the defaults taken from the docs.

    # The prompt to show when in interactive mode.
    # prompt = '(Pdb++) '

    # Highlight line numbers and the current line when showing the longlist of a function or when in sticky mode.
    highlight = True

    # File encoding. Useful when there are international characters in your string literals or comments.
    encoding = "utf-8"

    # Determine whether pdb++ starts in sticky mode or not.
    sticky_by_default = True

    # The color to use for line numbers.
    # line_number_color = Color.turquoise

    # The color to use for file names when printing the stack entries.
    # filename_color = Color.yellow

    # The SGR parameters for the ANSI escape sequence to highlight the current
    # line. This is set inside the SGR escape sequence \e[%sm where \e is the
    # ESC character and %s the given value. See SGR parameters. The following
    # means “reset all colors” (0), set foreground color to 18 (48;5;18), and
    # background to 21. The default uses the default foreground (39) and
    # background (49) colors, inversed (7).
    # current_line_color = "39;49;7"

    # If pygments is installed and highlight == True, apply syntax highlight to
    # the source code when showing the longlist of a function or when in sticky
    # mode.
    use_pygments = True

    # Passed directly to the pygments.formatters.TerminalFormatter constructor.
    # Selects the color scheme to use, depending on the background color of your
    # terminal. If you have a light background color, try to set it to 'light'.
    bg = "gruvbox-dark"

    # Passed directly to the pygments.formatters.TerminalFormatter constructor.
    # It expects a dictionary that maps token types to (lightbg, darkbg) color names or None (default: None = use builtin colorscheme).
    colorscheme = {"lightbg": "gruvbox-light", "darkgb": "gruvbox-dark"}

    # The command to invoke when using the edit command. By default, it uses
    # $EDITOR if set, else vi. The command must support the standard notation
    # COMMAND +n filename to open filename at line n. emacs and vi are known to support this.
    # editor = "${EDITOR:-vi}"

    # Truncate lines which exceed the terminal width.
    # truncate_long_lines = True

    # Shell command to execute when starting the pdb prompt and the terminal
    # window is not focused. Useful to e.g. play a sound to alert the user that
    # the execution of the program stopped. It requires the wmctrl module.
    # exec_if_unfocused = None

    # Old versions of pytest crash when you execute pdb.set_trace() in a test,
    # but the standard output is captured (i.e., without the -s option, which is
    # the default behavior). When this option is on, the stdout capturing is
    # automatically disabled before showing the interactive prompt.
    # disable_pytest_capturing = False

    # Certain frames can be hidden by default. If enabled, the commands
    # hf_unhide, hf_hide, and hf_list can be used to control display of them.
    # enable_hidden_frames = True

    # If enable_hidden_frames is True this controls if the number of hidden
    # frames gets displayed.
    # show_hidden_frames_count = True

    # This method is called during the initialization of the Pdb class. Useful
    # to do complex setup.
    # def setup(self, pdb):
    # pass

    # Display tracebacks for errors via Pdb.error, that come from Pdb.default
    # (i.e. the execution of an unrecognized pdb command), and are not a direct
    # cause of the expression itself (e.g. NameError with a command like
    # doesnotexist).
    # With this option disabled only *** exception string gets printed, which
    # often misses useful context.
    # show_traceback_on_error = True

    # This option sets the limit to be used with traceback.format_exception,
    # when show_traceback_on_error is enabled.
    # show_traceback_on_error_limit = None
