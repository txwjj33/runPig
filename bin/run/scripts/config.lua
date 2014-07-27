
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2
DEBUG_FPS = true

math.randomseed(os.time())

-- design resolution
CONFIG_SCREEN_WIDTH  = 640
CONFIG_SCREEN_HEIGHT = 960

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"

GAME_TEXTURE_DATA_FILENAME  = "AllSprites.plist"
GAME_TEXTURE_IMAGE_FILENAME = "AllSprites.png"

MAP_MOVE_SPEED = 200
ROLE_JUMP_SPEED = 500
GRAVITY = -800

ROLE_POS_X = 5
ROLE_POS_Y = 5

WIN_WIDTH = 1280
WIN_HEIGHT = 720

DIAMOND_SCORE = 100

--每个大关卡对应的小关卡数量
LEVEL_NUM_CONF = 
{
    [0] = 1,
    [1] = 6,
    [2] = 4,
    [3] = 3,
    [4] = 2,
    [5] = 2,
    [6] = 2,
    [7] = 2,
    [8] = 1,
    [8] = 1,
    [9] = 1,
}

--循环地图难度的最小最大值
LEVEL_RECYCLE_MIN = 7
LEVEL_RECYCLE_MAX = 9

checkMap = true
if checkMap then
    for k, v in ipairs(LEVEL_NUM_CONF) do
        for i = 1, v do
            local mapPath = string.format("levels/%d.%d.tmx", k, i)
            print(mapPath)
	        local map = CCTMXTiledMap:create(mapPath)
            if not map then
                print(mapPath .. "does not exist or has problems")
            end
        end
    end
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
--CONFIG_SCREEN_ORIENTATION = "portrait"

---- design resolution
--CONFIG_SCREEN_WIDTH  = 640
--CONFIG_SCREEN_HEIGHT = 960

---- auto scale mode
--CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
