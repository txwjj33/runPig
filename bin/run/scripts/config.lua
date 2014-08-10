
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1
DEBUG_FPS = true

ANDOIRD = false

--开启碰撞检测区域显示
DEBUG_COLLSION = true

math.randomseed(os.time())

-- design resolution
CONFIG_SCREEN_WIDTH  = 1280
CONFIG_SCREEN_HEIGHT = 720

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = kResolutionExactFit

GAME_TEXTURE_DATA_FILENAME  = "AllSprites.plist"
GAME_TEXTURE_IMAGE_FILENAME = "AllSprites.png"

GRAVITY = 0

MAP_MOVE_SPEED_LIMIT = 830
MAP_MOVE_SPEED = 630
ROLE_JUMP_SPEED = 0
ROLE_FALL_SPEED = 0

JUMP_GE_ZI_HOR = 7
JUMP_GE_ZI_VER = 3

TILE_WIDTH = 60

--作弊模式，点击restart以后复活
CHEATING_MODE = false 

--速度改变的间隔
SPEED_CHANGE_TIME = 30

--速度改变的增加
SPEED_CHANGE_NUM = 10

--第一个障碍物上面的顶点预留的碰撞像素
STUCK_TOP_JULI = 8

ROLE_POS_X = 5
ROLE_POS_Y = 3

WIN_WIDTH = 1280
WIN_HEIGHT = 720

DIAMOND_SCORE = 100

--每个大关卡对应的小关卡数量
LEVEL_NUM_CONF = 
{
    [0] = 1,
    [1] = 11,
    [2] = 11,
    [3] = 8,
    [4] = 6,
    [5] = 4,
    [6] = 3,
    [7] = 3,
    [8] = 2,
    [9] = 2,
}

--循环地图难度的最小最大值
LEVEL_RECYCLE_MIN = 7
LEVEL_RECYCLE_MAX = 9

checkMap = false
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
--CONFIG_SCREEN_ORIENTATION = "sensorLandscape"

---- design resolution
--CONFIG_SCREEN_WIDTH  = 640
--CONFIG_SCREEN_HEIGHT = 960

---- auto scale mode
--CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
