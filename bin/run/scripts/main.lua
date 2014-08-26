
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

CCFileUtils:sharedFileUtils():addSearchPath("res/")
require("game")
game.startup()

--function get_dir_file(dirpath,func)
--    --os.execute("dir " .. dirpath .. " /s > temp.txt")
--    os.execute('dir "' .. dirpath .. '" /s > temp.txt')
--    io.input("temp.txt")
--    local dirname = ""
--    local filename = ""
--    for line in io.lines() do
--        local a,b,c
--        --匹配目录
--        a,b,c=string.find(line,"^%s*(.+)%s+的目录")
--        if a then
--         dirname = c
--         --print(c)
--     end
--     --匹配文件
--        a,b,c=string.find(line,"^%d%d%d%d%-%d%d%-%d%d%s-%d%d:%d%d%s-[%d%,]+%s+(.+)%s-$")
--        if a then
--         filename = c
--         --print(c)
--         func(dirname .. "\\" .. filename)
--        end
--     --print(line)
--    end
--end
----获取指定的最后一个字符的位置
--function get_last_word(all,word)
--    local b = 0
--    local last = nil
--    while true do
--        local s,e = string.find(all, word, b) -- find 'next' word
--        if s == nil then
--         break
--        else
--         last = s
--        end
--         b = s + string.len(word)
--    end
--    return last
--end

------可以通过get_last_word获取指定文件的相应路径和相应文件名
----filepath = "c:\\windows\\explorer.exe"
----pos=get_last_word(filepath,"\\")
----dirname=string.sub(filepath,1,pos)
----filename=string.sub(filepath,pos+1,-1)
----print(dirname,filename)
------使用print函数对C:\Program Files\Internet Explorer文件夹下文件进行处理
------get_dir_file('"C:\\Program Files\\Internet Explorer"',print)
----get_dir_file('D:\\levels',print)