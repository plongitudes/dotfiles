return {
  'nvim-treesitter/nvim-tree-docs',
  config = function()
    require "nvim-treesitter.configs".setup({
      tree_docs = {
        enable = true,
        keymaps = {
          doc_all_in_range = "fdd",
          doc_node_at_cursor = "fdd",
          edit_doc_at_cursor = "fde"
        }
        --spec_config = {
          --jsdoc = {
            --slots = {
              --class = {author = true}
            --}
          --}
        --}
      }
    })
  end
}
