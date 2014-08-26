LOCAL_PATH := $(call my-dir)

COCOS2DX_PATH := $(LOCAL_PATH)/../../../../lib/cocos2d-x

include $(CLEAR_VARS)

LOCAL_MODULE := game_shared

LOCAL_MODULE_FILENAME := libgame

LOCAL_SRC_FILES := hellocpp/main.cpp \
    ../../sources/AppDelegate.cpp \
    ../../sources/LuaSpine.cpp \
    ../../sources/LuaTalkingData.cpp \
    ../../sources/spine/PolygonBatch.cpp \
    ../../sources/spine/SkeletonAnimation.cpp \
    ../../sources/spine/SkeletonRenderer.cpp \
    ../../sources/spine/spine-cocos2dx.cpp \
    ../../spine-c/src/spine/Animation.c \
    ../../spine-c/src/spine/AnimationState.c \
    ../../spine-c/src/spine/AnimationStateData.c \
    ../../spine-c/src/spine/Atlas.c \
    ../../spine-c/src/spine/AtlasAttachmentLoader.c \
    ../../spine-c/src/spine/Attachment.c \
    ../../spine-c/src/spine/AttachmentLoader.c \
    ../../spine-c/src/spine/Bone.c \
    ../../spine-c/src/spine/BoneData.c \
    ../../spine-c/src/spine/BoundingBoxAttachment.c \
    ../../spine-c/src/spine/Event.c \
    ../../spine-c/src/spine/EventData.c \
    ../../spine-c/src/spine/extension.c \
    ../../spine-c/src/spine/Json.c \
    ../../spine-c/src/spine/MeshAttachment.c \
    ../../spine-c/src/spine/RegionAttachment.c \
    ../../spine-c/src/spine/Skeleton.c \
    ../../spine-c/src/spine/SkeletonBounds.c \
    ../../spine-c/src/spine/SkeletonData.c \
    ../../spine-c/src/spine/SkeletonJson.c \
    ../../spine-c/src/spine/Skin.c \
    ../../spine-c/src/spine/SkinnedMeshAttachment.c \
    ../../spine-c/src/spine/Slot.c \
    ../../spine-c/src/spine/SlotData.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../sources \
$(LOCAL_PATH)/../../spine-c/include \
$(COCOS2DX_PATH)/../../talkingData \
$(COCOS2DX_PATH)/../../talkingData/platform/android

LOCAL_CFLAGS += -D__GXX_EXPERIMENTAL_CXX0X__ -std=gnu++11 -Wno-psabi -DCC_LUA_ENGINE_ENABLED=1 $(ANDROID_COCOS2D_BUILD_FLAGS)

LOCAL_WHOLE_STATIC_LIBRARIES := quickcocos2dx
LOCAL_WHOLE_STATIC_LIBRARIES += cocos2dx-talkingdata

include $(BUILD_SHARED_LIBRARY)

$(call import-module,lib/proj.android)
$(call import-module,talkingData/proj.android/jni)
