vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    local msg = string.format("Register: %s", vim.fn.reg_recording())
    _MACRO_RECORDING_STATUS = true
    vim.notify(msg, vim.log.levels.INFO, {
      title = "Macro Recording",
      keep = function() return _MACRO_RECORDING_STATUS end,
    })
  end,
  group = vim.api.nvim_create_augroup("NoiceMacroNotfication", { clear = true })
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    _MACRO_RECORDING_STATUS = false
    vim.notify("Success!", vim.log.levels.INFO, {
      title = "Macro Recording End",
      timeout = 2000,
    })
  end,
  group = vim.api.nvim_create_augroup("NoiceMacroNotficationDismiss", { clear = true })
})
