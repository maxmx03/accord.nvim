describe('storage', function()
  local password = 'pass'
  ---@type records
  local record = {
    password = password,
    col = 1,
    line = 1,
    opts = {},
    ns_id = 0,
    buffer = 0,
  }
  ---@type storage
  local Storage = require 'accord.storage'
  local storage = Storage:new { where = 'state', filename = 'accord_test' }

  test('set', function()
    local records = { record, record }
    storage:set(records)
    local lines = vim.fn.readfile(storage.location)
    lines = vim.json.decode(lines[1])
    assert.is_table(lines)
    assert.is_true(#lines > 0)
    assert.are_same(records, lines)
  end)

  test('get_by_password', function()
    local lines = storage:get_by_password(password)
    assert.are_same(record, lines[1])
  end)
end)
