SHARE_IMAGE = "http://ww3.sinaimg.cn/large/005Mkwjugw1elowt1dc6kj303c03cglk.jpg"

-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1
DEBUG_FPS = true

ANDOIRD = false

DEFAULT_FONT = "AGENTORANGE.ttf"

--开启以后所有仙人掌无效
CHEAT_MODE = false

--钻石复活的无敌时间
RESUME_WU_DI_TIME = 2

--测试单个地图
MAP_TEST = false
MAP_TEST_FILE = "levels/_test.tmx"

MAPS_TEST = false
--MAP_TEST_FILES = 
--{
--    "levels/0_7_7_1.tmx",
--    "levels/1_7_10_1.tmx",
--    "levels/2_10_10_1.tmx",
--}

MAP_TEST_FILES = 
{
    "levels/0_7_7_1.tmx",
    "levels/1_7_7_1.tmx",
    "levels/2_7_6_1.tmx",
}

--开启碰撞检测区域显示
DEBUG_COLLSION = true

math.randomseed(os.time())

-- design resolution
CONFIG_SCREEN_WIDTH  = 1280
CONFIG_SCREEN_HEIGHT = 720

-- auto scale mode
--CONFIG_SCREEN_AUTOSCALE = kResolutionExactFit

GAME_TEXTURE_DATA_FILENAME  = "AllSprites.plist"
GAME_TEXTURE_IMAGE_FILENAME = "AllSprites.png"

--地图最大速度和初始速度
MAP_MOVE_SPEED_LIMIT = 730
MAP_MOVE_SPEED_START = 480

--继续游戏需要的钻石数量
DIAMOND_RESUME_GAME_NEEDED = 50

--跳跃的水平距离和垂直距离（格子数）
JUMP_GE_ZI_HOR = 7
JUMP_GE_ZI_VER = 3
--跳跃的垂直的多余像素
JUMP_XIANG_SU_VER = 10
--碰到上面格子后反弹速度系数
JUMP_FAN_TAN_XI_SHU = 0.1

--速度改变的间隔
SPEED_CHANGE_TIME = 5
--速度改变的增加
SPEED_CHANGE_NUM = 10

--第一个障碍物上面的顶点预留的碰撞像素
STUCK_TOP_JULI = 18
--小猪碰撞体积的参数
ROLE_HOR_XIANG_SU = 5   --左右遗留像素
ROLE_VER_XIANG_SU = 5   --上下遗留像素

--小猪初始位置（离左上的格子数）
ROLE_POS_X = 5
ROLE_POS_Y = 5

--同时显示几列的碰撞形状
ROAD_SHAPE_NUM = 20

WIN_WIDTH = 1280
WIN_HEIGHT = 720

--钻石分数
DIAMOND_SCORE = 100

--关卡最大值
LEVEL_MAX = 7

SHARE_TEXT =
{
    {max = 5, str = "情场菜鸟"},
    {max = 15, str = "情场老手"},
    {max = 30, str = "情场专家"},
    {max = 50, str = "情兽"},
    {max = 100, str = "情圣"},
    {max = 100000, str = "花丛浪子"},
}

function getchenhao(count)
    local str = nil
    for k, v in ipairs(SHARE_TEXT) do
        if count <= v.max then
            str = v.str
            break
        end
    end
    if not str then str = "花丛浪子" end
    return str
end

function getShareTest(count)
    if count < SHARE_TEXT[1].max then
        return "我在猎艳之旅中才跨过了" .. count .. "个障碍，就已经不行了呢，果然还是个“情场小菜鸟”，谁来陪我练练？"
    end
    return "我在这次猎艳之旅中跨过" .. count .. "个障碍，已经身经百战！获得了“" .. getchenhao(count) .. "”称号！"
end

function getShareTitle(count)
    return "你已成为“" .. getchenhao(count) .. "”！"
end

--加入新的地图后用于检查地图
checkMap = false
if checkMap then

allMapTrue = true
    
local function printTableToFileHelp(file, luaTable, indent)
    indent = indent or 0
    for k, v in pairs(luaTable) do
        if k == "mapPos" then
            local szPrefix = string.rep("    ", indent)
            local line = szPrefix .. "[\"mapPos\"] = ccp(" .. v.x .. ", " .. v.y .. "),"
            file:write(line .. "\n")
        else
            if type(k) == "string" then
                k = string.format("%q", k)
            end
            local szSuffix = ""
            if type(v) == "table" then
                szSuffix = "{"
            end
            local szPrefix = string.rep("    ", indent)
            formatting = szPrefix.."["..k.."]".." = "..szSuffix
            if type(v) == "table" then
                file:write(formatting .. "\n")
                printTableToFileHelp(file, v, indent + 1)
                file:write(szPrefix.."}," .. "\n")
            else
                local szValue = ""
                if type(v) == "string" then
                    szValue = string.format("%q", v)
                else
                    szValue = tostring(v)
                end
                file:write(formatting..szValue.."," .. "\n")
            end
        end
    end
end

local function printTableToFile(fileName, luaTable, indent)
    if not luaTable then
        DLOG("nil")
        return
    end

    local file = io.open(fileName, "w+b")
    file:write("local confTable = {\n")
    printTableToFileHelp(file, luaTable, 1)
    file:write("}\n")
    file:write("\n")
    file:write("return confTable\n")
    io.close(file)
end
    --for k, v in ipairs(LEVEL_NUM_CONF) do
    --    for i = 1, v do
    --        local mapPath = string.format("levels/%d.%d.tmx", k, i)
    --        print(mapPath)
	   --     local map = CCTMXTiledMap:create(mapPath)
    --        if not map then
    --            print(mapPath .. "does not exist or has problems")
    --        end
    --    end
    --end
    
    local function listfile ( dir, ext, recursive )
        -- set default
        dir = dir or 'res/levels'
        ext = ext or '*.*'                      -- *.* file / directory
        local rec = recursive and '/s' or ''   -- search sub directory

        -- trim quote proc
        dir = string.gsub( dir, "[\\/]", '\\' )
        dir = string.find( dir, '^%b""$') and string.sub( dir, 2, -2 ) or dir
        dir = string.find( dir, '.+\\$') and string.sub( dir, 1, -2 ) or dir

        if string.find( ext, "^[\\/]$" ) then  -- directory flag /ad
            ext = '/ad'
        else                                    -- file flag /a-d and ext *.* or etc.
            ext = '/a-d '..ext
        end

        -- in linux use ls
        --local cmd = "pushd %q &dir %s /b %s &popd"
        local cmd = "dir %s /b"
        cmd = string.format( cmd, dir, ext, rec )

        local t = {}
        local list = io.popen( cmd )
        for line in list:lines() do
            line = recursive and line or dir..'/'..line
            t[#t+1] = line
            --print(line)
        end
        list:close()

        return t
    end

    local function printChinese ( path, index )
        local file = io.open(path, 'r')
        if not file then
            print( "Invalid path: ", index, path )
            return
        end

        local text = file:read('*all')
        if not text then
            print( "Nil text path: ", index, path )
            file:close()
            return
        end

        print( string.format( "[%03d] Text of %q", index, path ) )
        for seg in string.gmatch( text,  "[^%w%p%s%c]+" ) do -- allow tab \t to replace %c to \\r\\n
            print( seg )
        end
        file:close()
    end

    local function getNums(path)
        local nums = {}
        local pos1 = string.find(path, '/') 
        local pos = string.find(path, '_') 
        while pos do
            local num = string.sub(path, pos1 + 1, pos -1)
            table.insert(nums, tonumber(num))
            pos1 = pos
            pos = string.find(path, '_', pos +1)
        end 
        pos = string.find(path, ".tmx", pos1 +1)
        if not pos then print(path) end
        local num = string.sub(path, pos1 + 1, pos - 1)
        table.insert(nums, tonumber(num))
        return nums
    end

    local mapCount = {}
    local function changeName(path)
        
        local file = io.open(path, 'r')
        if file then
            local nums = getNums(path)
            local content = file:read('*a')
            local name1 = string.format("lev111112/%d_%d_%d_", nums[1], nums[3], nums[4])
            if mapCount[name1] then
                mapCount[name1] = mapCount[name1] + 1
            else
                mapCount[name1] = 1
            end
            local name = name1 .. mapCount[name1] .. ".tmx"
            print(name)
            local tfile = io.open(name, 'w+b')
            tfile:write(content)
        end
    end

     local function checkMap ( path, index, t )
        local file = io.open(path, 'r')
        if not file then
            --print( "Invalid path: ", index, path )
            return
        end

        --local mapPath = string.format("levels/%d.%d.tmx", k, i)
        --string.gsub(path, '\\', "/")
        

        print("map path: " .. path)
	    local map = CCTMXTiledMap:create(path)
        if not map then
            print(path .. "does not exist or has problems")
            allMapTrue = false
            return
        end

        local mapSize = map:getMapSize()
        local layer = map:layerNamed("road1")
        local nums = getNums(path)

        if nums[1] ~= 0 and mapSize.width < 22 then
            print(path .. "map width must larger than 22!!")
            allMapTrue = false
            return
        end 

        local function checkTile(isStart)
            local startPos, endPos, step, num
            if isStart then
                startPos, endPos, step, num = 0, mapSize.width - 1, 1, nums[2]
            else
                startPos, endPos, step, num = mapSize.width - 1, 0, -1, nums[3]
            end

            for i = startPos, endPos, step do
                for j = 0, mapSize.height -1 do
                    local tile = layer:tileAt(ccp(i, j))
                    if tile then
                        if j == num - 1 then
                            return true
                        else
                            print("---------------------------------------------------") 
                            if isStart then 
                                print("check start false!!!!!!!!!!!!!!!!!!!!!") 
                                allMapTrue = false
                            else
                                print("check end false!!!!!!!!!!!!!!!!!!!!!") 
                                allMapTrue = false
                            end
                            print("---------------------------------------------------") 
                            return false
                            --assert(0)
                        end
                    end
                end
            end
        end

        local function checkXianJie()
            local nextLevel = 0
            if nums[1] < LEVEL_MAX then
                nextLevel = nums[1] + 1
            else
                nextLevel = LEVEL_MAX
            end

            for index1, path1 in ipairs(t) do
                if path1 ~= path and not string.find(path1, "mszy") then 
                    local nums1 = getNums(path1)
                    if nums1[1] == nil then print("error tmx, path " .. path1) end

                    if nums1[1] == nextLevel then
                        if nums1[2] == nums[3] then
                            --print("check xian jie is true")
                            return true
                        end
                    elseif nums1[1] > nextLevel then
                        return false
                    end
                end
            end

            return false
        end

        
        if not layer then
            print(path .. "does not exist layer road1")
            allMapTrue = false
        else
            if checkTile(true) then 
                --print("check start is true") 
            end
            if checkTile(false) then 
            --print("check end is true") 
            end
        end

        if not checkXianJie() then
            print("---------------------------------------------------") 
            print("check xian jie is false")
            print("---------------------------------------------------") 
            allMapTrue = false
        end
    end

    local function main ()
        -- your search directory
        --local dir = [[D:\levels]]
        local t = listfile( dir, "*.txt", false ) -- false to search sub dir

        for index, path in ipairs(t) do
            checkMap(path,index, t)
            --changeName(path)
        end

        if allMapTrue then
            print("all map is checked!!")
        else
            print("some map has problems, please fix it!!!!!!!!")
        end

        local names = {}
        for index, path in ipairs(t) do
            table.insert(names, string.sub(path, 5))
        end

        printTableToFile("scripts/mapName.lua", names)
    end

    startTime = os.time()
    main()
    print( string.format("\n>> This function cost: %s ms", tostring(os.time()-startTime) ) )
end


---- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
--DEBUG = 1

---- display FPS stats on screen
--DEBUG_FPS = true

---- dump memory info every 10 seconds
--DEBUG_MEM = false

---- load deprecated API
--LOAD_DEPRECATED_API = false

---- load shortcodes API
--LOAD_SHORTCODES_API = true

---- screen orientation
--CONFIG_SCREEN_ORIENTATION = "sensorLandscape"

---- design resolution
--CONFIG_SCREEN_WIDTH  = 640
--CONFIG_SCREEN_HEIGHT = 960

---- auto scale mode
--CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
