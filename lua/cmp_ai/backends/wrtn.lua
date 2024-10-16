local requests = require('cmp_ai.requests')

Wrtn = requests:new(nil)
BASE_URL = 'http://localhost:5000/ask'

function Wrtn:new(o, params)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.headers = {}
  return o
end


function extract_code_block(markdown_text)
    local matches = {}
    for block in markdown_text:gmatch("```%w+\n(.-)```") do
        table.insert(matches, block)
    end
    if #matches >= 1 then
        return matches[1]
    else
        return ''
    end
end


function Wrtn:complete(lines_before, lines_after, cb)
  local data = {
    before_text = lines_before,
    after_text = lines_after,
    filetype = vim.o.filetype
  }
  self:Get(BASE_URL, self.headers, data, function(answer)
    local new_data = {}
    if answer.error ~= nil then
      vim.notify('Wrtn error: ' .. answer.error)
      return
    end
    table.insert(new_data, answer.result)
    cb(new_data)
  end)
end

function Wrtn:test()
  self:complete('def factorial(n)\n    if', '    return ans\n', function(data)
    dump(data)
  end)
end

return Wrtn
