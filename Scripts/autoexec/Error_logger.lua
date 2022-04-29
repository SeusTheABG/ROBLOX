local tab = string.rep(' ', 5)

game.ScriptContext.ErrorDetailed:Connect(function(message, stacktrace)
   local str = message .. '\n' .. tab .. 'Stack Begin'
   if stacktrace then
       str = str .. '\n' .. tab .. stacktrace
   end
   str = str .. tab .. 'Stack End'
   warn(str)
end)