-- Heirline config
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

vim.cmd([[
  function! StatusDiagnostic() abort
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    let msgs = []
    if get(info, 'error', 0)
      call add(msgs, 'E' . info['error'])
    endif
    if get(info, 'warning', 0)
      call add(msgs, 'W' . info['warning'])
    endif
    return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
  endfunction
]])

-- colors
local colors = {
  bright_bg = utils.get_highlight("Folded").bg,
  bright_fg = utils.get_highlight("Folded").fg,
  red = utils.get_highlight("DiagnosticError").fg,
  dark_red = utils.get_highlight("DiffDelete").bg,
  green = utils.get_highlight("String").fg,
  blue = utils.get_highlight("Function").fg,
  gray = utils.get_highlight("NonText").fg,
  orange = utils.get_highlight("Constant").fg,
  purple = utils.get_highlight("Statement").fg,
  cyan = utils.get_highlight("Special").fg,
  diag_warn = utils.get_highlight("DiagnosticWarn").fg,
  diag_error = utils.get_highlight("DiagnosticError").fg,
  diag_hint = utils.get_highlight("DiagnosticHint").fg,
  diag_info = utils.get_highlight("DiagnosticInfo").fg,
  git_del = utils.get_highlight("diffDeleted").fg,
  git_add = utils.get_highlight("diffAdded").fg,
  git_change = utils.get_highlight("diffChanged").fg,
}
require("heirline").load_colors(colors)

-- gets the mode
local ViMode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = {
      n = "Normal",
      no = "Normal?",
      nov = "Normal (Visual)",
      noV = "Normal (V-Line)",
      ["no\22"] = "Normal (V-Block)",
      niI = "Normal (Insert)",
      niR = "Normal (Replace)",
      niV = "Normal (V-Replace)",
      nt = "Normal (Terminal)",
      v = "Visual",
      vs = "Visual Select",
      V = "Visual Line",
      Vs = "V-Line Select",
      ["\22"] = "Visual Block",
      ["\22s"] = "V-Block Select",
      s = "Select",
      S = "Select Line",
      ["\19"] = "Select Block",
      i = "Insert",
      ic = "Insert Complete",
      ix = "Insert Complete",
      R = "Replace",
      Rc = "Replace Complete",
      Rx = "Replace Complete",
      Rv = "V-Replace",
      Rvc = "V-Replace Complete",
      Rvx = "V-Replace Complete",
      c = "Command",
      cv = "Ex-Mode",
      r = "Hit Enter",
      rm = "More",
      ["r?"] = "Confirm",
      ["!"] = "Shell",
      t = "Terminal",
    },
    mode_colors = {
      n = "green",
      i = "blue",
      v = "purple",
      V = "purple",
      ["\22"] = "purple",
      c = "yellow",
      s = "cyan",
      S = "cyan",
      ["\19"] = "cyan",
      R = "red",
      r = "green",
      ["!"] = "orange",
      t = "yellow",
    }
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = function(self)
    return " %2("..self.mode_names[self.mode].."%)"
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true, }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- Also allows the statusline to be re-evaluated when entering operator-pending mode
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}
-- gets the file info
local FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then return "[No Name]" end
    -- now, if the filename would occupy more than 1/4th of the available
      -- space, we trim the file path to its initials
      -- See Flexible Components section below for dynamic truncation
      if not conditions.width_percent_below(#filename, 0.25) then
        filename = vim.fn.pathshorten(filename)
      end
      return filename
    end,
    hl = { fg = utils.get_highlight("Directory").fg },
  }

  local FileFlags = {
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = "[+]",
      hl = { fg = "green" },
    },
    {
      condition = function()
        return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = "",
      hl = { fg = "yellow" },
    },
  }

  -- Now, let's say that we want the filename color to change if the buffer is
    -- modified. Of course, we could do that directly using the FileName.hl field,
      -- but we'll see how easy it is to alter existing components using a "modifier"
      -- component

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "cyan", bold = true, force=true }
          end
        end,
      }

      -- let's add the children to our FileNameBlock component
      FileNameBlock = utils.insert(FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        FileFlags,
        { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
        )
      local FileType = {
        provider = function()
          return string.lower(vim.bo.filetype)
        end,
        h1 = { fg = utils.get_highlight("Type").fg, bold = true },
      }

      local FileEncoding = {
        provider = function()
          local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
          -- return enc ~= 'utf-8' and enc:upper()
          return enc:upper()
        end
      }

      local FileFormat = {
        provider = function()
          local fmt = vim.bo.fileformat
          -- return fmt ~= 'unix' and fmt:upper()
          return fmt:upper()
        end
      }

      local FileSize = {
        provider = function()
          -- stackoverflow, compute human readable file size
          local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
          local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
          fsize = (fsize < 0 and 0) or fsize
          if fsize < 1024 then
            return fsize..suffix[1]
          end
          local i = math.floor((math.log(fsize) / math.log(1024)))
          return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
        end
      }

      local FileLastModified = {
        -- did you know? Vim is full of functions!
        provider = function()
          local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
          return (ftime > 0) and os.date("%c", ftime)
        end
      }

      -- gets cursor position
      local Ruler = {
        -- %l = current line number
        -- %L = number of lines in the buffer
        -- %c = column number
        -- %P = percentage through file of displayed window
        provider = "%7(%l/%3L%):%2c %P",
      }

      local ScrollBar ={
        static = {
          sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
          -- Another variant, because the more choice the better.
          -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
        },
        provider = function(self)
          local curr_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_line_count(0)
          local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
          return string.rep(self.sbar[i], 2)
        end,
        hl = { fg = "diag_warn" }
      }


      local SearchResults = {
        condition = function(self)
          local lines = vim.api.nvim_buf_line_count(0)
          if lines > 50000 then return end

          local query = vim.fn.getreg("/")
          if query == "" then return end

          if query:find("@") then return end

          local search_count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
          local active = false
          if vim.v.hlsearch and vim.v.hlsearch == 1 and search_count.total > 0 then
            active = true
          end
          if not active then return end

          query = query:gsub([[^\V]], "")
          query = query:gsub([[\<]], ""):gsub([[\>]], "")

          self.query = query
          self.count = search_count
          return true
        end,
        {
          provider = function(self)
            return table.concat({
                ' ', self.query, ' ', self.count.current, '/', self.count.total, ' '
              })
          end,
          hl = { fg = "black" , bg = "orange" } -- your highlight goes here
        },
        Space -- A separator after, if section is active, without highlight.
        }

        -- local SearchCount = {
          --     condition = function()
            --         return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
          --     end,
          --     init = function(self)
            --         local ok, search = pcall(vim.fn.searchcount)
            --         if ok and search.total then
              --             self.search = search
            --         end
          --     end,
          --     provider = function(self)
            --         local search = self.search
            --         return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
          --     end,
        -- }

        local MacroRec = {
          condition = function()
            return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
          end,
          provider = " ",
          hl = { fg = "orange", bold = true },
          utils.surround({ "[", "]" }, nil, {
              provider = function()
                return vim.fn.reg_recording()
              end,
              hl = { fg = "green", bold = true },
            }),
          update = {
            "RecordingEnter",
            "RecordingLeave",
            -- redraw the statusline on recording events
            -- Note: this is only required for Neovim < 0.9.0. Newer versions of
            -- Neovim ensure `statusline` is redrawn on those events.
            callback = vim.schedule_wrap(function()
              vim.cmd("redrawstatus")
            end),
          }
        }

        -- diagnostics
        local Diagnostics = {

          condition = conditions.has_diagnostics,

          static = {
            error_icon = 'E', -- vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
            warn_icon = 'W', -- vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
            info_icon = 'I', -- vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
            hint_icon = 'H', -- vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
          },

          init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
          end,

          update = { "DiagnosticChanged", "BufEnter" },

          {
            provider = "![",
          },
          {
            provider = function(self)
              -- 0 is just another output, we can decide to print it or not!
              return self.errors > 0 and (self.error_icon .. self.errors .. " ")
            end,
            hl = { fg = "diag_error" },
          },
          {
            provider = function(self)
              return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
            end,
            hl = { fg = "diag_warn" },
          },
          {
            provider = function(self)
              return self.info > 0 and (self.info_icon .. self.info .. " ")
            end,
            hl = { fg = "diag_info" },
          },
          {
            provider = function(self)
              return self.hints > 0 and (self.hint_icon .. self.hints)
            end,
            hl = { fg = "diag_hint" },
          },
          {
            provider = "]",
          },
        }

        -- special buffer namings
        local TerminalName = {
          -- we could add a condition to check that buftype == 'terminal'
          -- or we could do that later (see #conditional-statuslines below)
            provider = function()
              local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
              return " " .. tname
            end,
            hl = { fg = "blue", bold = true },
          }

          local HelpFileName = {
            condition = function()
              return vim.bo.filetype == "help"
            end,
            provider = function()
              local filename = vim.api.nvim_buf_get_name(0)
              return vim.fn.fnamemodify(filename, ":t")
            end,
            hl = { fg = colors.blue },
          }

          -- combining the statusline
          ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode })
          local Align = { provider = "%=" }
          local Space ={ provider = " " }

          local DefaultStatusline = {
            ViMode, Space, Space, Diagnostics, Align, FileNameBlock, 
            Align,
          Space, SearchResults, Space, MacroRec, Space, FileType, Space, Ruler, Space, ScrollBar, Space, FileSize, Space, FileEncoding, Space, FileFormat, Space }

          local InactiveStatusline = {
            condition = conditions.is_not_active,
            FileType, Space, FileName, Align,
          }

          local SpecialStatusline = {
            condition = function()
              return conditions.buffer_matches({
                  buftype = { "nofile", "prompt", "help", "quickfix" },
                  filetype = { "^git.*", "fugitive" },
                })
            end,

            FileType, Space, HelpFileName, Align
          }

          local TerminalStatusline = {

            condition = function()
              return conditions.buffer_matches({ buftype = { "terminal" } })
            end,

            hl = { bg = "dark_red" },

            -- Quickly add a condition to the ViMode to only show it when buffer is active!
            { condition = conditions.is_active, ViMode, Space }, FileType, Space, TerminalName, Align,
          }

          local StatusLines = {

            hl = function()
              if conditions.is_active() then
                return "StatusLine"
              else
                return "StatusLineNC"
              end
            end,

            -- the first statusline with no condition, or which condition returns true is used.
            -- think of it as a switch case with breaks to stop fallthrough.
            fallthrough = false,

            SpecialStatusline, TerminalStatusline, InactiveStatusline, DefaultStatusline,
          }

          -- tabline
          local TablineBufnr = {
            provider = function(self)
              return tostring(self.bufnr) .. ". "
            end,
            hl = "Comment",
          }

          -- we redefine the filename component, as we probably only want the tail and not the relative path
          local TablineFileName = {
            provider = function(self)
              -- self.filename will be defined later, just keep looking at the example!
              local filename = self.filename
              filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
              return filename
            end,
            hl = function(self)
              return { bold = self.is_active or self.is_visible, italic = true }
            end,
          }

          -- this looks exactly like the FileFlags component that we saw in
          -- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
          -- also, we are adding a nice icon for terminal buffers.
          local TablineFileFlags = {
            {
              condition = function(self)
                return vim.api.nvim_buf_get_option(self.bufnr, "modified")
              end,
              provider = "[+]",
              hl = { fg = "green" },
            },
            {
              condition = function(self)
                return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
                or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
              end,
              provider = function(self)
                if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
                  return "  "
                else
                  return ""
                end
              end,
              hl = { fg = "orange" },
            },
          }

          -- Here the filename block finally comes together
          local TablineFileNameBlock = {
            init = function(self)
              self.filename = vim.api.nvim_buf_get_name(self.bufnr)
            end,
            hl = function(self)
              if self.is_active then
                return "TabLineSel"
                -- why not?
              -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
                --     return { fg = "gray" }
              else
                return "TabLine"
              end
            end,
            on_click = {
              callback = function(_, minwid, _, button)
                if (button == "m") then -- close on mouse middle click
                  vim.schedule(function()
                    vim.api.nvim_buf_delete(minwid, { force = false })
                  end)
                else
                  vim.api.nvim_win_set_buf(0, minwid)
                end
              end,
              minwid = function(self)
                return self.bufnr
              end,
              name = "heirline_tabline_buffer_callback",
            },
            TablineBufnr,
            FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
            TablineFileName,
            TablineFileFlags,
          }

          -- a nice "x" button to close the buffer
          local TablineCloseButton = {
            condition = function(self)
              return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
            end,
            { provider = " " },
            {
              provider = "",
              hl = { fg = "gray" },
              on_click = {
                callback = function(_, minwid)
                  vim.schedule(function()
                    vim.api.nvim_buf_delete(minwid, { force = false })
                  end)
                  vim.cmd.redrawtabline()
                end,
                minwid = function(self)
                  return self.bufnr
                end,
                name = "heirline_tabline_close_buffer_callback",
              },
            },
          }

          -- The final touch!
          local TablineBufferBlock = utils.surround({ "", "" }, function(self)
            if self.is_active then
              return utils.get_highlight("TabLineSel").bg
            else
              return utils.get_highlight("TabLine").bg
            end
          end, { TablineFileNameBlock, TablineCloseButton })

        -- this is the default function used to retrieve buffers
          local get_bufs = function()
            return vim.tbl_filter(function(bufnr)
              return vim.api.nvim_buf_get_option(bufnr, "buflisted")
            end, vim.api.nvim_list_bufs())
        end

        -- initialize the buflist cache
        local buflist_cache = {}

        -- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
        vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
            callback = function()
              vim.schedule(function()
                local buffers = get_bufs()
                for i, v in ipairs(buffers) do
                  buflist_cache[i] = v
                end
                for i = #buffers + 1, #buflist_cache do
                  buflist_cache[i] = nil
                end

                -- check how many buffers we have and set showtabline accordingly
                if #buflist_cache > 1 then
                  vim.o.showtabline = 2 -- always
                else
                  vim.o.showtabline = 1 -- only when #tabpages > 1
                end
              end)
            end,
          })

        local BufferLine = utils.make_buflist(
          TablineBufferBlock,
          { provider = " ", hl = { fg = "gray" } },
          { provider = " ", hl = { fg = "gray" } },
          -- out buf_func simply returns the buflist_cache
          function()
            return buflist_cache
          end,
          -- no cache, as we're handling everything ourselves
          false
          )

        local TablinePicker = {
          condition = function(self)
            return self._show_picker
          end,
          init = function(self)
            local bufname = vim.api.nvim_buf_get_name(self.bufnr)
            bufname = vim.fn.fnamemodify(bufname, ":t")
            local label = bufname:sub(1, 1)
            local i = 2
            while self._picker_labels[label] do
              if i > #bufname then
                break
              end
              label = bufname:sub(i, i)
              i = i + 1
            end
            self._picker_labels[label] = self.bufnr
            self.label = label
          end,
          provider = function(self)
            return self.label
          end,
          hl = { fg = "red", bold = true },
        }

        vim.keymap.set("n", "gbp", function()
          local tabline = require("heirline").tabline
          local buflist = tabline._buflist[1]
          buflist._picker_labels = {}
          buflist._show_picker = true
          vim.cmd.redrawtabline()
          local char = vim.fn.getcharstr()
          local bufnr = buflist._picker_labels[char]
          if bufnr then
            vim.api.nvim_win_set_buf(0, bufnr)
          end
          buflist._show_picker = false
          vim.cmd.redrawtabline()
        end)

        local Tabpage = {
          provider = function(self)
            return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
          end,
          hl = function(self)
            if not self.is_active then
              return "TabLine"
            else
              return "TabLineSel"
            end
          end,
        }

        local TabpageClose = {
          provider = "%999X  %X",
          hl = "TabLine",
        }

        local TabPages = {
          -- only show this component if there's 2 or more tabpages
            condition = function()
              return #vim.api.nvim_list_tabpages() >= 2
            end,
            { provider = "%=" },
            utils.make_tablist(Tabpage),
            TabpageClose,
          }

          local TabLineOffset = {
            condition = function(self)
              local win = vim.api.nvim_tabpage_list_wins(0)[1]
              local bufnr = vim.api.nvim_win_get_buf(win)
              self.winid = win

              if vim.bo[bufnr].filetype == "NvimTree" then
                self.title = "NvimTree"
                return true
              -- elseif vim.bo[bufnr].filetype == "TagBar" then
                --     ...
              end
            end,

            provider = function(self)
              local title = self.title
              local width = vim.api.nvim_win_get_width(self.winid)
              local pad = math.ceil((width - #title) / 2)
              return string.rep(" ", pad) .. title .. string.rep(" ", pad)
            end,

            hl = function(self)
              if vim.api.nvim_get_current_win() == self.winid then
                return "TablineSel"
              else
                return "Tabline"
              end
            end,
          }

          local TabLine = { TabLineOffset, BufferLine, TabPages }

require("heirline").setup({ statusline = StatusLines, winbar = WinBars })
          require("heirline").setup( {
              statusline = StatusLines,
              tabline = TabLine,
            })

          -- Yep, with heirline we're driving manual!
          vim.o.showtabline = 2
          vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
