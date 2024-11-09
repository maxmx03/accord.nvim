describe('storage', function()
  local password = 'pass'
  local id = vim.uv.now()
  ---@type records
  local record = {
    password = password,
    col = 1,
    line = 1,
    opts = {
      id = id,
    },
    ns_id = 0,
    buffer = 0,
  }
  local record2 = vim.deepcopy(record)
  record2.opts.id = 10

  ---@type storage
  local Storage = require 'accord.storage'
  local storage = Storage:new { where = 'state', filename = 'accord_test' }

  test('set', function()
    local records = { record, record, record2 }
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

  test('filter', function()
    storage:filter(id, password)
    local lines = storage:get_all()
    assert.are_same(record2, lines[1])
  end)
end)
