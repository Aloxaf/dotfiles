import re

from xkeysnail.transform import *

# Alt + N to choose completion
define_keymap(
    lambda wm_class: wm_class in ("jetbrains-clion", "jetbrains-pycharm"),
    {
        K("LM-Key_2"): [K("down"), K("down"), K("tab")],
        K("LM-Key_3"): [K("down"), K("down"), K("tab")],
        K("LM-Key_4"): [K("down"), K("down"), K("down"), K("tab")],
    },
    "JetBrains",
)

WHITE_LIST = ("Emacs", "Alacritty", "konsole", "jetbrains-clion", "jetbrains-pycharm")

define_keymap(
    lambda wm_class: wm_class not in WHITE_LIST,
    {
        # Cursor
        K("LC-b"): with_mark(K("left")),
        K("LC-f"): with_mark(K("right")),
        K("LC-p"): with_mark(K("up")),
        K("LC-n"): with_mark(K("down")),
        # Forward/Backward word
        K("LM-b"): with_mark(K("LC-left")),
        K("LM-f"): with_mark(K("LC-right")),
        # Beginning/End of line
        K("LC-a"): with_mark(K("home")),
        K("LC-e"): with_mark(K("end")),
        # Page up/down
        K("LM-v"): with_mark(K("page_up")),
        K("LC-v"): with_mark(K("page_down")),
        # Beginning/End of file
        K("LShift-LM-comma"): with_mark(K("LC-home")),
        K("LShift-LM-dot"): with_mark(K("LC-end")),
        # Delete line
        K("LC-LShift-backspace"): [
            K("home"),
            K("LShift-end"),
            K("LC-x"),
            K("backspace"),
        ],
        # Newline
        K("C-m"): K("enter"),
        K("C-j"): K("enter"),
        # Copy
        K("LC-w"): [K("LC-x"), set_mark(False)],
        K("LM-w"): [K("LC-c"), set_mark(False)],
        K("LC-y"): [K("LC-v"), set_mark(False)],
        # Delete
        K("LC-d"): [K("delete"), set_mark(False)],
        K("LM-d"): [K("LC-delete"), set_mark(False)],
        # Kill line
        K("LC-k"): [K("LShift-end"), K("LC-x"), set_mark(False)],
        # Undo
        K("LC-slash"): [K("LC-z"), set_mark(False)],
        K("LC-LShift-slash"): [K("LC-z"), set_mark(False)],
        # Redo
        K("LC-LShift-minus"): [K("LC-z")],
        K("LM-LShift-minus"): [K("LC-LShift-z")],
        # Mark
        K("LC-space"): set_mark(True),
        K("LC-M-space"): with_or_set_mark(K("LC-right")),
        # Search
        K("LC-s"): K("LC-f"),
        # Cancel
        K("LC-g"): [K("esc"), set_mark(False)],
        # Escape
        K("LC-q"): escape_next_key,
        # C-x YYY
        K("LC-x"): {
            # C-x h (select all)
            K("h"): K("LC-a"),
            # C-x C-f (open)
            K("LC-f"): K("LC-o"),
            # C-x C-s (save)
            K("LC-s"): K("LC-s"),
            # C-x k (kill tab)
            K("k"): K("LC-w"),
            # C-x C-c (exit)
            K("LC-c"): K("LC-q"),
            # cancel
            K("LC-g"): pass_through_key,
            # C-x u (undo)
            K("u"): [K("LC-z"), set_mark(False)],
        },
    },
    "Emacs-like keys",
)
