return {
    "GCBallesteros/jupytext.nvim",
    -- event = "BufReadPre *.ipynb",
    lazy = false,
    opts = {
        style = "hydrogen", -- Use # %% cell markers
        output_extension = "py", -- Edit as .py
        force_ft = "python",
    },
}
