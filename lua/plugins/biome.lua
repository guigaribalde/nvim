---@type LazySpec
return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.formatters_by_ft then opts.formatters_by_ft = {} end
      -- https://biomejs.dev/internals/language-support/
      local supported_ft = {
        "astro",
        "css",
        "graphql",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "svelte",
        "typescript",
        "typescriptreact",
        "vue",
      }
      for _, ft in ipairs(supported_ft) do
        opts.formatters_by_ft[ft] = { "biome" }
      end

      -- Configure biome formatter with fix option
      if not opts.formatters then opts.formatters = {} end
      opts.formatters.biome = {
        args = { "format", "--stdin-file-path", "$FILENAME" },
      }
    end,
  },
  -- Add LSP configuration for biome
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      if not opts.config then opts.config = {} end

      -- Configure biome LSP server
      opts.config.biome = {
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern("biome.json", "biome.jsonc")(fname)
            or require("lspconfig.util").find_git_ancestor(fname)
        end,
        single_file_support = false,
        settings = {
          biome = {
            enabled = true,
          },
        },
      }

      -- Set up auto-fix on save
      if not opts.autocmds then opts.autocmds = {} end
      opts.autocmds.biome_autofix = {
        {
          event = "BufWritePre",
          desc = "Biome auto-fix on save",
          callback = function(args)
            local buf = args.buf
            local ft = vim.bo[buf].filetype
            local supported_ft = {
              "astro",
              "css",
              "graphql",
              "javascript",
              "javascriptreact",
              "json",
              "jsonc",
              "svelte",
              "typescript",
              "typescriptreact",
              "vue",
            }

            -- Check if current filetype is supported by biome
            local is_supported = false
            for _, supported in ipairs(supported_ft) do
              if ft == supported then
                is_supported = true
                break
              end
            end

            if is_supported then
              -- Get biome clients
              local clients = vim.lsp.get_clients { bufnr = buf, name = "biome" }
              if #clients > 0 then
                -- Apply code actions for auto-fix
                local params = vim.lsp.util.make_range_params(0, "utf-8")
                params.context = {
                  only = { "source.fixAll.biome", "source.organizeImports.biome" },
                  diagnostics = vim.lsp.diagnostic.get_line_diagnostics(buf),
                }

                local results = vim.lsp.buf_request_sync(buf, "textDocument/codeAction", params, 3000)
                if results then
                  for _, result in pairs(results) do
                    if result.result then
                      for _, action in ipairs(result.result) do
                        if action.edit then
                          vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                        elseif action.command then
                          vim.lsp.buf.execute_command(action.command)
                        end
                      end
                    end
                  end
                end
              end
            end
          end,
        },
      }
    end,
  },
}
