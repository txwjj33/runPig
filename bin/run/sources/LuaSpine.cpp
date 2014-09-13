/*
** Lua binding: spine
** Generated automatically by tolua++-1.0.92 on 09/13/14 17:09:30.
*/

/****************************************************************************
 Copyright (c) 2011 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

extern "C" {
#include "tolua_fix.h"
}

#include <map>
#include <string>
#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "spine/SkeletonRenderer.h"
#include "spine/SkeletonAnimation.h"
#include <spine/spine.h>
#include "LuaSpine.h"
#include "LuaExport.h"

using namespace spine;
using namespace cocos2d;
using namespace CocosDenshion;

/* Exported function */
TOLUA_API int  tolua_spine_open (lua_State* tolua_S);

#include "LuaSpine.h"

/* function to release collected object via destructor */
#ifdef __cplusplus

static int tolua_collect_CCRect (lua_State* tolua_S)
{
 CCRect* self = (CCRect*) tolua_tousertype(tolua_S,1,0);
    Mtolua_delete(self);
    return 0;
}

static int tolua_collect_SkeletonRenderer (lua_State* tolua_S)
{
 SkeletonRenderer* self = (SkeletonRenderer*) tolua_tousertype(tolua_S,1,0);
    Mtolua_delete(self);
    return 0;
}

static int tolua_collect_SkeletonAnimation (lua_State* tolua_S)
{
 SkeletonAnimation* self = (SkeletonAnimation*) tolua_tousertype(tolua_S,1,0);
    Mtolua_delete(self);
    return 0;
}
#endif


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"LuaExport");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(LuaExport)), "LuaExport");
 tolua_usertype(tolua_S,"spEventType");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spEventType)), "spEventType");
 tolua_usertype(tolua_S,"spSlot");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spSlot)), "spSlot");
 tolua_usertype(tolua_S,"SkeletonAnimation");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(SkeletonAnimation)), "SkeletonAnimation");
 tolua_usertype(tolua_S,"spSkeletonData");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spSkeletonData)), "spSkeletonData");
 tolua_usertype(tolua_S,"spSkeleton");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spSkeleton)), "spSkeleton");
 tolua_usertype(tolua_S,"spEvent");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spEvent)), "spEvent");
 tolua_usertype(tolua_S,"spTrackEntry");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spTrackEntry)), "spTrackEntry");
 tolua_usertype(tolua_S,"spAnimationStateData");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spAnimationStateData)), "spAnimationStateData");
 tolua_usertype(tolua_S,"spAnimationState");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spAnimationState)), "spAnimationState");
 tolua_usertype(tolua_S,"spAttachment");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spAttachment)), "spAttachment");
 tolua_usertype(tolua_S,"spBone");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spBone)), "spBone");
 tolua_usertype(tolua_S,"SkeletonRenderer");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(SkeletonRenderer)), "SkeletonRenderer");
 tolua_usertype(tolua_S,"CCNode");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(CCNode)), "CCNode");
 tolua_usertype(tolua_S,"CCRect");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(CCRect)), "CCRect");
 tolua_usertype(tolua_S,"spAtlas");
 toluafix_add_type_mapping(CLASS_HASH_CODE(typeid(spAtlas)), "spAtlas");
}

/* get function: skeleton of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_get_SkeletonRenderer_skeleton_ptr
static int tolua_get_SkeletonRenderer_skeleton_ptr(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'skeleton'",NULL);
#endif
   tolua_pushusertype(tolua_S,(void*)self->skeleton,"spSkeleton");
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: skeleton of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_set_SkeletonRenderer_skeleton_ptr
static int tolua_set_SkeletonRenderer_skeleton_ptr(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'skeleton'",NULL);
  if (!tolua_isusertype(tolua_S,2,"spSkeleton",0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->skeleton = ((spSkeleton*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: rootBone of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_get_SkeletonRenderer_rootBone_ptr
static int tolua_get_SkeletonRenderer_rootBone_ptr(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'rootBone'",NULL);
#endif
   tolua_pushusertype(tolua_S,(void*)self->rootBone,"spBone");
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: rootBone of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_set_SkeletonRenderer_rootBone_ptr
static int tolua_set_SkeletonRenderer_rootBone_ptr(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'rootBone'",NULL);
  if (!tolua_isusertype(tolua_S,2,"spBone",0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->rootBone = ((spBone*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: timeScale of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_get_SkeletonRenderer_timeScale
static int tolua_get_SkeletonRenderer_timeScale(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'timeScale'",NULL);
#endif
  tolua_pushnumber(tolua_S,(lua_Number)self->timeScale);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: timeScale of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_set_SkeletonRenderer_timeScale
static int tolua_set_SkeletonRenderer_timeScale(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'timeScale'",NULL);
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->timeScale = ((float)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: debugSlots of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_get_SkeletonRenderer_debugSlots
static int tolua_get_SkeletonRenderer_debugSlots(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'debugSlots'",NULL);
#endif
  tolua_pushboolean(tolua_S,(bool)self->debugSlots);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: debugSlots of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_set_SkeletonRenderer_debugSlots
static int tolua_set_SkeletonRenderer_debugSlots(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'debugSlots'",NULL);
  if (!tolua_isboolean(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->debugSlots = ((bool)  tolua_toboolean(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: debugBones of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_get_SkeletonRenderer_debugBones
static int tolua_get_SkeletonRenderer_debugBones(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'debugBones'",NULL);
#endif
  tolua_pushboolean(tolua_S,(bool)self->debugBones);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: debugBones of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_set_SkeletonRenderer_debugBones
static int tolua_set_SkeletonRenderer_debugBones(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'debugBones'",NULL);
  if (!tolua_isboolean(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->debugBones = ((bool)  tolua_toboolean(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: premultipliedAlpha of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_get_SkeletonRenderer_premultipliedAlpha
static int tolua_get_SkeletonRenderer_premultipliedAlpha(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'premultipliedAlpha'",NULL);
#endif
  tolua_pushboolean(tolua_S,(bool)self->premultipliedAlpha);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: premultipliedAlpha of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_set_SkeletonRenderer_premultipliedAlpha
static int tolua_set_SkeletonRenderer_premultipliedAlpha(lua_State* tolua_S)
{
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'premultipliedAlpha'",NULL);
  if (!tolua_isboolean(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->premultipliedAlpha = ((bool)  tolua_toboolean(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* method: createWithData of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_createWithData00
static int tolua_spine_SkeletonRenderer_createWithData00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"spSkeletonData",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  spSkeletonData* skeletonData = ((spSkeletonData*)  tolua_tousertype(tolua_S,2,0));
  bool ownsSkeletonData = ((bool)  tolua_toboolean(tolua_S,3,false));
  {
   SkeletonRenderer* tolua_ret = (SkeletonRenderer*)  SkeletonRenderer::createWithData(skeletonData,ownsSkeletonData);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonRenderer");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'createWithData'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: createWithFile of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_createWithFile00
static int tolua_spine_SkeletonRenderer_createWithFile00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"spAtlas",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  spAtlas* atlas = ((spAtlas*)  tolua_tousertype(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonRenderer* tolua_ret = (SkeletonRenderer*)  SkeletonRenderer::createWithFile(skeletonDataFile,atlas,scale);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonRenderer");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'createWithFile'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: createWithFile of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_createWithFile01
static int tolua_spine_SkeletonRenderer_createWithFile01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* atlasFile = ((const char*)  tolua_tostring(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonRenderer* tolua_ret = (SkeletonRenderer*)  SkeletonRenderer::createWithFile(skeletonDataFile,atlasFile,scale);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonRenderer");
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonRenderer_createWithFile00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_new00
static int tolua_spine_SkeletonRenderer_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"spSkeletonData",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  spSkeletonData* skeletonData = ((spSkeletonData*)  tolua_tousertype(tolua_S,2,0));
  bool ownsSkeletonData = ((bool)  tolua_toboolean(tolua_S,3,false));
  {
   SkeletonRenderer* tolua_ret = (SkeletonRenderer*)  Mtolua_new((SkeletonRenderer)(skeletonData,ownsSkeletonData));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonRenderer");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_new00_local
static int tolua_spine_SkeletonRenderer_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"spSkeletonData",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  spSkeletonData* skeletonData = ((spSkeletonData*)  tolua_tousertype(tolua_S,2,0));
  bool ownsSkeletonData = ((bool)  tolua_toboolean(tolua_S,3,false));
  {
   SkeletonRenderer* tolua_ret = (SkeletonRenderer*)  Mtolua_new((SkeletonRenderer)(skeletonData,ownsSkeletonData));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonRenderer");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_new01
static int tolua_spine_SkeletonRenderer_new01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"spAtlas",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  spAtlas* atlas = ((spAtlas*)  tolua_tousertype(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonRenderer* tolua_ret = (SkeletonRenderer*)  Mtolua_new((SkeletonRenderer)(skeletonDataFile,atlas,scale));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonRenderer");
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonRenderer_new00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_new01_local
static int tolua_spine_SkeletonRenderer_new01_local(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"spAtlas",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  spAtlas* atlas = ((spAtlas*)  tolua_tousertype(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonRenderer* tolua_ret = (SkeletonRenderer*)  Mtolua_new((SkeletonRenderer)(skeletonDataFile,atlas,scale));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonRenderer");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonRenderer_new00_local(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_new02
static int tolua_spine_SkeletonRenderer_new02(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* atlasFile = ((const char*)  tolua_tostring(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonRenderer* tolua_ret = (SkeletonRenderer*)  Mtolua_new((SkeletonRenderer)(skeletonDataFile,atlasFile,scale));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonRenderer");
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonRenderer_new01(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_new02_local
static int tolua_spine_SkeletonRenderer_new02_local(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* atlasFile = ((const char*)  tolua_tostring(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonRenderer* tolua_ret = (SkeletonRenderer*)  Mtolua_new((SkeletonRenderer)(skeletonDataFile,atlasFile,scale));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonRenderer");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonRenderer_new01_local(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: delete of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_delete00
static int tolua_spine_SkeletonRenderer_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'delete'", NULL);
#endif
  Mtolua_delete(self);
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'delete'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: update of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_update00
static int tolua_spine_SkeletonRenderer_update00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
  float deltaTime = ((float)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'update'", NULL);
#endif
  {
   self->update(deltaTime);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'update'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: draw of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_draw00
static int tolua_spine_SkeletonRenderer_draw00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'draw'", NULL);
#endif
  {
   self->draw();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'draw'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: boundingBox of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_boundingBox00
static int tolua_spine_SkeletonRenderer_boundingBox00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'boundingBox'", NULL);
#endif
  {
   CCRect tolua_ret = (CCRect)  self->boundingBox();
   {
#ifdef __cplusplus
    void* tolua_obj = Mtolua_new((CCRect)(tolua_ret));
     tolua_pushusertype(tolua_S,tolua_obj,"CCRect");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
#else
    void* tolua_obj = tolua_copy(tolua_S,(void*)&tolua_ret,sizeof(CCRect));
     tolua_pushusertype(tolua_S,tolua_obj,"CCRect");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
#endif
   }
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'boundingBox'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: updateWorldTransform of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_updateWorldTransform00
static int tolua_spine_SkeletonRenderer_updateWorldTransform00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'updateWorldTransform'", NULL);
#endif
  {
   self->updateWorldTransform();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'updateWorldTransform'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setToSetupPose of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_setToSetupPose00
static int tolua_spine_SkeletonRenderer_setToSetupPose00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setToSetupPose'", NULL);
#endif
  {
   self->setToSetupPose();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setToSetupPose'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setBonesToSetupPose of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_setBonesToSetupPose00
static int tolua_spine_SkeletonRenderer_setBonesToSetupPose00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setBonesToSetupPose'", NULL);
#endif
  {
   self->setBonesToSetupPose();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setBonesToSetupPose'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setSlotsToSetupPose of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_setSlotsToSetupPose00
static int tolua_spine_SkeletonRenderer_setSlotsToSetupPose00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setSlotsToSetupPose'", NULL);
#endif
  {
   self->setSlotsToSetupPose();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setSlotsToSetupPose'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: findBone of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_findBone00
static int tolua_spine_SkeletonRenderer_findBone00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"const SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const SkeletonRenderer* self = (const SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
  const char* boneName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'findBone'", NULL);
#endif
  {
   spBone* tolua_ret = (spBone*)  self->findBone(boneName);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"spBone");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'findBone'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: findSlot of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_findSlot00
static int tolua_spine_SkeletonRenderer_findSlot00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"const SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const SkeletonRenderer* self = (const SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
  const char* slotName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'findSlot'", NULL);
#endif
  {
   spSlot* tolua_ret = (spSlot*)  self->findSlot(slotName);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"spSlot");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'findSlot'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setSkin of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_setSkin00
static int tolua_spine_SkeletonRenderer_setSkin00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
  const char* skinName = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setSkin'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->setSkin(skinName);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setSkin'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getAttachment of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_getAttachment00
static int tolua_spine_SkeletonRenderer_getAttachment00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"const SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const SkeletonRenderer* self = (const SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
  const char* slotName = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* attachmentName = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getAttachment'", NULL);
#endif
  {
   spAttachment* tolua_ret = (spAttachment*)  self->getAttachment(slotName,attachmentName);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"spAttachment");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getAttachment'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setAttachment of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_setAttachment00
static int tolua_spine_SkeletonRenderer_setAttachment00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
  const char* slotName = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* attachmentName = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setAttachment'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->setAttachment(slotName,attachmentName);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setAttachment'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setOpacityModifyRGB of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_setOpacityModifyRGB00
static int tolua_spine_SkeletonRenderer_setOpacityModifyRGB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
  bool value = ((bool)  tolua_toboolean(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setOpacityModifyRGB'", NULL);
#endif
  {
   self->setOpacityModifyRGB(value);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setOpacityModifyRGB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: isOpacityModifyRGB of class  SkeletonRenderer */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonRenderer_isOpacityModifyRGB00
static int tolua_spine_SkeletonRenderer_isOpacityModifyRGB00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonRenderer",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonRenderer* self = (SkeletonRenderer*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'isOpacityModifyRGB'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->isOpacityModifyRGB();
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'isOpacityModifyRGB'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* get function: state of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_get_SkeletonAnimation_state_ptr
static int tolua_get_SkeletonAnimation_state_ptr(lua_State* tolua_S)
{
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'state'",NULL);
#endif
   tolua_pushusertype(tolua_S,(void*)self->state,"spAnimationState");
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: state of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_set_SkeletonAnimation_state_ptr
static int tolua_set_SkeletonAnimation_state_ptr(lua_State* tolua_S)
{
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!self) tolua_error(tolua_S,"invalid 'self' in accessing variable 'state'",NULL);
  if (!tolua_isusertype(tolua_S,2,"spAnimationState",0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  self->state = ((spAnimationState*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* method: createWithData of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_createWithData00
static int tolua_spine_SkeletonAnimation_createWithData00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"spSkeletonData",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  spSkeletonData* skeletonData = ((spSkeletonData*)  tolua_tousertype(tolua_S,2,0));
  {
   SkeletonAnimation* tolua_ret = (SkeletonAnimation*)  SkeletonAnimation::createWithData(skeletonData);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonAnimation");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'createWithData'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: createWithFile of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_createWithFile00
static int tolua_spine_SkeletonAnimation_createWithFile00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"spAtlas",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  spAtlas* atlas = ((spAtlas*)  tolua_tousertype(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonAnimation* tolua_ret = (SkeletonAnimation*)  SkeletonAnimation::createWithFile(skeletonDataFile,atlas,scale);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonAnimation");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'createWithFile'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: createWithFile of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_createWithFile01
static int tolua_spine_SkeletonAnimation_createWithFile01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* atlasFile = ((const char*)  tolua_tostring(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonAnimation* tolua_ret = (SkeletonAnimation*)  SkeletonAnimation::createWithFile(skeletonDataFile,atlasFile,scale);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonAnimation");
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonAnimation_createWithFile00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_new00
static int tolua_spine_SkeletonAnimation_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"spSkeletonData",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  spSkeletonData* skeletonData = ((spSkeletonData*)  tolua_tousertype(tolua_S,2,0));
  {
   SkeletonAnimation* tolua_ret = (SkeletonAnimation*)  Mtolua_new((SkeletonAnimation)(skeletonData));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonAnimation");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_new00_local
static int tolua_spine_SkeletonAnimation_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"spSkeletonData",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  spSkeletonData* skeletonData = ((spSkeletonData*)  tolua_tousertype(tolua_S,2,0));
  {
   SkeletonAnimation* tolua_ret = (SkeletonAnimation*)  Mtolua_new((SkeletonAnimation)(skeletonData));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonAnimation");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_new01
static int tolua_spine_SkeletonAnimation_new01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"spAtlas",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  spAtlas* atlas = ((spAtlas*)  tolua_tousertype(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonAnimation* tolua_ret = (SkeletonAnimation*)  Mtolua_new((SkeletonAnimation)(skeletonDataFile,atlas,scale));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonAnimation");
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonAnimation_new00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_new01_local
static int tolua_spine_SkeletonAnimation_new01_local(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"spAtlas",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  spAtlas* atlas = ((spAtlas*)  tolua_tousertype(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonAnimation* tolua_ret = (SkeletonAnimation*)  Mtolua_new((SkeletonAnimation)(skeletonDataFile,atlas,scale));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonAnimation");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonAnimation_new00_local(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_new02
static int tolua_spine_SkeletonAnimation_new02(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* atlasFile = ((const char*)  tolua_tostring(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonAnimation* tolua_ret = (SkeletonAnimation*)  Mtolua_new((SkeletonAnimation)(skeletonDataFile,atlasFile,scale));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonAnimation");
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonAnimation_new01(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_new02_local
static int tolua_spine_SkeletonAnimation_new02_local(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* skeletonDataFile = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* atlasFile = ((const char*)  tolua_tostring(tolua_S,3,0));
  float scale = ((float)  tolua_tonumber(tolua_S,4,0));
  {
   SkeletonAnimation* tolua_ret = (SkeletonAnimation*)  Mtolua_new((SkeletonAnimation)(skeletonDataFile,atlasFile,scale));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"SkeletonAnimation");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
tolua_lerror:
 return tolua_spine_SkeletonAnimation_new01_local(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: delete of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_delete00
static int tolua_spine_SkeletonAnimation_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'delete'", NULL);
#endif
  Mtolua_delete(self);
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'delete'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: update of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_update00
static int tolua_spine_SkeletonAnimation_update00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  float deltaTime = ((float)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'update'", NULL);
#endif
  {
   self->update(deltaTime);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'update'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setAnimationStateData of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_setAnimationStateData00
static int tolua_spine_SkeletonAnimation_setAnimationStateData00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"spAnimationStateData",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  spAnimationStateData* stateData = ((spAnimationStateData*)  tolua_tousertype(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setAnimationStateData'", NULL);
#endif
  {
   self->setAnimationStateData(stateData);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setAnimationStateData'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setMix of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_setMix00
static int tolua_spine_SkeletonAnimation_setMix00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  const char* fromAnimation = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* toAnimation = ((const char*)  tolua_tostring(tolua_S,3,0));
  float duration = ((float)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setMix'", NULL);
#endif
  {
   self->setMix(fromAnimation,toAnimation,duration);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setMix'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setAnimation of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_setAnimation00
static int tolua_spine_SkeletonAnimation_setAnimation00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  int trackIndex = ((int)  tolua_tonumber(tolua_S,2,0));
  const char* name = ((const char*)  tolua_tostring(tolua_S,3,0));
  bool loop = ((bool)  tolua_toboolean(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setAnimation'", NULL);
#endif
  {
   spTrackEntry* tolua_ret = (spTrackEntry*)  self->setAnimation(trackIndex,name,loop);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"spTrackEntry");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setAnimation'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addAnimation of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_addAnimation00
static int tolua_spine_SkeletonAnimation_addAnimation00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  int trackIndex = ((int)  tolua_tonumber(tolua_S,2,0));
  const char* name = ((const char*)  tolua_tostring(tolua_S,3,0));
  bool loop = ((bool)  tolua_toboolean(tolua_S,4,0));
  float delay = ((float)  tolua_tonumber(tolua_S,5,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addAnimation'", NULL);
#endif
  {
   spTrackEntry* tolua_ret = (spTrackEntry*)  self->addAnimation(trackIndex,name,loop,delay);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"spTrackEntry");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addAnimation'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getCurrent of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_getCurrent00
static int tolua_spine_SkeletonAnimation_getCurrent00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  int trackIndex = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getCurrent'", NULL);
#endif
  {
   spTrackEntry* tolua_ret = (spTrackEntry*)  self->getCurrent(trackIndex);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"spTrackEntry");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getCurrent'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: clearTracks of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_clearTracks00
static int tolua_spine_SkeletonAnimation_clearTracks00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'clearTracks'", NULL);
#endif
  {
   self->clearTracks();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'clearTracks'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: clearTrack of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_clearTrack00
static int tolua_spine_SkeletonAnimation_clearTrack00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  int trackIndex = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'clearTrack'", NULL);
#endif
  {
   self->clearTrack(trackIndex);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'clearTrack'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onAnimationStateEvent of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_onAnimationStateEvent00
static int tolua_spine_SkeletonAnimation_onAnimationStateEvent00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,3,&tolua_err) || !tolua_isusertype(tolua_S,3,"spEventType",0,&tolua_err)) ||
     !tolua_isusertype(tolua_S,4,"spEvent",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  int trackIndex = ((int)  tolua_tonumber(tolua_S,2,0));
  spEventType type = *((spEventType*)  tolua_tousertype(tolua_S,3,0));
  spEvent* event = ((spEvent*)  tolua_tousertype(tolua_S,4,0));
  int loopCount = ((int)  tolua_tonumber(tolua_S,5,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'onAnimationStateEvent'", NULL);
#endif
  {
   self->onAnimationStateEvent(trackIndex,type,event,loopCount);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'onAnimationStateEvent'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: onTrackEntryEvent of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_onTrackEntryEvent00
static int tolua_spine_SkeletonAnimation_onTrackEntryEvent00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,3,&tolua_err) || !tolua_isusertype(tolua_S,3,"spEventType",0,&tolua_err)) ||
     !tolua_isusertype(tolua_S,4,"spEvent",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  int trackIndex = ((int)  tolua_tonumber(tolua_S,2,0));
  spEventType type = *((spEventType*)  tolua_tousertype(tolua_S,3,0));
  spEvent* event = ((spEvent*)  tolua_tousertype(tolua_S,4,0));
  int loopCount = ((int)  tolua_tonumber(tolua_S,5,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'onTrackEntryEvent'", NULL);
#endif
  {
   self->onTrackEntryEvent(trackIndex,type,event,loopCount);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'onTrackEntryEvent'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: isPlayAnimation of class  SkeletonAnimation */
#ifndef TOLUA_DISABLE_tolua_spine_SkeletonAnimation_isPlayAnimation00
static int tolua_spine_SkeletonAnimation_isPlayAnimation00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"SkeletonAnimation",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  SkeletonAnimation* self = (SkeletonAnimation*)  tolua_tousertype(tolua_S,1,0);
  const char* name = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'isPlayAnimation'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->isPlayAnimation(name);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'isPlayAnimation'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: showShareMenu of class  LuaExport */
#ifndef TOLUA_DISABLE_tolua_spine_LuaExport_showShareMenu00
static int tolua_spine_LuaExport_showShareMenu00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"LuaExport",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,0,&tolua_err) ||
     !tolua_isstring(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* content = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* image = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* title = ((const char*)  tolua_tostring(tolua_S,4,0));
  const char* des = ((const char*)  tolua_tostring(tolua_S,5,0));
  const char* url = ((const char*)  tolua_tostring(tolua_S,6,0));
  {
   LuaExport::showShareMenu(content,image,title,des,url);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'showShareMenu'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_spine_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  #ifdef __cplusplus
  tolua_cclass(tolua_S,"SkeletonRenderer","SkeletonRenderer","CCNode",tolua_collect_SkeletonRenderer);
  #else
  tolua_cclass(tolua_S,"SkeletonRenderer","SkeletonRenderer","CCNode",NULL);
  #endif
  tolua_beginmodule(tolua_S,"SkeletonRenderer");
   tolua_variable(tolua_S,"skeleton",tolua_get_SkeletonRenderer_skeleton_ptr,tolua_set_SkeletonRenderer_skeleton_ptr);
   tolua_variable(tolua_S,"rootBone",tolua_get_SkeletonRenderer_rootBone_ptr,tolua_set_SkeletonRenderer_rootBone_ptr);
   tolua_variable(tolua_S,"timeScale",tolua_get_SkeletonRenderer_timeScale,tolua_set_SkeletonRenderer_timeScale);
   tolua_variable(tolua_S,"debugSlots",tolua_get_SkeletonRenderer_debugSlots,tolua_set_SkeletonRenderer_debugSlots);
   tolua_variable(tolua_S,"debugBones",tolua_get_SkeletonRenderer_debugBones,tolua_set_SkeletonRenderer_debugBones);
   tolua_variable(tolua_S,"premultipliedAlpha",tolua_get_SkeletonRenderer_premultipliedAlpha,tolua_set_SkeletonRenderer_premultipliedAlpha);
   tolua_function(tolua_S,"createWithData",tolua_spine_SkeletonRenderer_createWithData00);
   tolua_function(tolua_S,"createWithFile",tolua_spine_SkeletonRenderer_createWithFile00);
   tolua_function(tolua_S,"createWithFile",tolua_spine_SkeletonRenderer_createWithFile01);
   tolua_function(tolua_S,"new",tolua_spine_SkeletonRenderer_new00);
   tolua_function(tolua_S,"new_local",tolua_spine_SkeletonRenderer_new00_local);
   tolua_function(tolua_S,".call",tolua_spine_SkeletonRenderer_new00_local);
   tolua_function(tolua_S,"new",tolua_spine_SkeletonRenderer_new01);
   tolua_function(tolua_S,"new_local",tolua_spine_SkeletonRenderer_new01_local);
   tolua_function(tolua_S,".call",tolua_spine_SkeletonRenderer_new01_local);
   tolua_function(tolua_S,"new",tolua_spine_SkeletonRenderer_new02);
   tolua_function(tolua_S,"new_local",tolua_spine_SkeletonRenderer_new02_local);
   tolua_function(tolua_S,".call",tolua_spine_SkeletonRenderer_new02_local);
   tolua_function(tolua_S,"delete",tolua_spine_SkeletonRenderer_delete00);
   tolua_function(tolua_S,"update",tolua_spine_SkeletonRenderer_update00);
   tolua_function(tolua_S,"draw",tolua_spine_SkeletonRenderer_draw00);
   tolua_function(tolua_S,"boundingBox",tolua_spine_SkeletonRenderer_boundingBox00);
   tolua_function(tolua_S,"updateWorldTransform",tolua_spine_SkeletonRenderer_updateWorldTransform00);
   tolua_function(tolua_S,"setToSetupPose",tolua_spine_SkeletonRenderer_setToSetupPose00);
   tolua_function(tolua_S,"setBonesToSetupPose",tolua_spine_SkeletonRenderer_setBonesToSetupPose00);
   tolua_function(tolua_S,"setSlotsToSetupPose",tolua_spine_SkeletonRenderer_setSlotsToSetupPose00);
   tolua_function(tolua_S,"findBone",tolua_spine_SkeletonRenderer_findBone00);
   tolua_function(tolua_S,"findSlot",tolua_spine_SkeletonRenderer_findSlot00);
   tolua_function(tolua_S,"setSkin",tolua_spine_SkeletonRenderer_setSkin00);
   tolua_function(tolua_S,"getAttachment",tolua_spine_SkeletonRenderer_getAttachment00);
   tolua_function(tolua_S,"setAttachment",tolua_spine_SkeletonRenderer_setAttachment00);
   tolua_function(tolua_S,"setOpacityModifyRGB",tolua_spine_SkeletonRenderer_setOpacityModifyRGB00);
   tolua_function(tolua_S,"isOpacityModifyRGB",tolua_spine_SkeletonRenderer_isOpacityModifyRGB00);
  tolua_endmodule(tolua_S);
  #ifdef __cplusplus
  tolua_cclass(tolua_S,"SkeletonAnimation","SkeletonAnimation","SkeletonRenderer",tolua_collect_SkeletonAnimation);
  #else
  tolua_cclass(tolua_S,"SkeletonAnimation","SkeletonAnimation","SkeletonRenderer",NULL);
  #endif
  tolua_beginmodule(tolua_S,"SkeletonAnimation");
   tolua_variable(tolua_S,"state",tolua_get_SkeletonAnimation_state_ptr,tolua_set_SkeletonAnimation_state_ptr);
   tolua_function(tolua_S,"createWithData",tolua_spine_SkeletonAnimation_createWithData00);
   tolua_function(tolua_S,"createWithFile",tolua_spine_SkeletonAnimation_createWithFile00);
   tolua_function(tolua_S,"createWithFile",tolua_spine_SkeletonAnimation_createWithFile01);
   tolua_function(tolua_S,"new",tolua_spine_SkeletonAnimation_new00);
   tolua_function(tolua_S,"new_local",tolua_spine_SkeletonAnimation_new00_local);
   tolua_function(tolua_S,".call",tolua_spine_SkeletonAnimation_new00_local);
   tolua_function(tolua_S,"new",tolua_spine_SkeletonAnimation_new01);
   tolua_function(tolua_S,"new_local",tolua_spine_SkeletonAnimation_new01_local);
   tolua_function(tolua_S,".call",tolua_spine_SkeletonAnimation_new01_local);
   tolua_function(tolua_S,"new",tolua_spine_SkeletonAnimation_new02);
   tolua_function(tolua_S,"new_local",tolua_spine_SkeletonAnimation_new02_local);
   tolua_function(tolua_S,".call",tolua_spine_SkeletonAnimation_new02_local);
   tolua_function(tolua_S,"delete",tolua_spine_SkeletonAnimation_delete00);
   tolua_function(tolua_S,"update",tolua_spine_SkeletonAnimation_update00);
   tolua_function(tolua_S,"setAnimationStateData",tolua_spine_SkeletonAnimation_setAnimationStateData00);
   tolua_function(tolua_S,"setMix",tolua_spine_SkeletonAnimation_setMix00);
   tolua_function(tolua_S,"setAnimation",tolua_spine_SkeletonAnimation_setAnimation00);
   tolua_function(tolua_S,"addAnimation",tolua_spine_SkeletonAnimation_addAnimation00);
   tolua_function(tolua_S,"getCurrent",tolua_spine_SkeletonAnimation_getCurrent00);
   tolua_function(tolua_S,"clearTracks",tolua_spine_SkeletonAnimation_clearTracks00);
   tolua_function(tolua_S,"clearTrack",tolua_spine_SkeletonAnimation_clearTrack00);
   tolua_function(tolua_S,"onAnimationStateEvent",tolua_spine_SkeletonAnimation_onAnimationStateEvent00);
   tolua_function(tolua_S,"onTrackEntryEvent",tolua_spine_SkeletonAnimation_onTrackEntryEvent00);
   tolua_function(tolua_S,"isPlayAnimation",tolua_spine_SkeletonAnimation_isPlayAnimation00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"LuaExport","LuaExport","",NULL);
  tolua_beginmodule(tolua_S,"LuaExport");
   tolua_function(tolua_S,"showShareMenu",tolua_spine_LuaExport_showShareMenu00);
  tolua_endmodule(tolua_S);

  { /* begin embedded lua code */
   int top = lua_gettop(tolua_S);
   static const unsigned char B[] = {
    10,102,117,110, 99,116,105,111,110, 32,116,111,108,117, 97,
     46,114,101,115,101,116, 99,102,117,110, 99,116,105,111,110,
     40, 99,108,115, 44, 32,109,101,116,104,111,100,110, 97,109,
    101, 41, 10,108,111, 99, 97,108, 32, 99,102,117,110, 99,116,
    105,111,110, 32, 61, 32,116,111,108,117, 97, 46,103,101,116,
     99,102,117,110, 99,116,105,111,110, 40, 99,108,115, 44, 32,
    109,101,116,104,111,100,110, 97,109,101, 41, 10,105,102, 32,
     99,102,117,110, 99,116,105,111,110, 32,116,104,101,110, 10,
     99,108,115, 91,109,101,116,104,111,100,110, 97,109,101, 93,
     32, 61, 32, 99,102,117,110, 99,116,105,111,110, 10,101,110,
    100, 10,101,110,100, 45, 45, 45, 45, 45,32
   };
   tolua_dobuffer(tolua_S,(char*)B,sizeof(B),"tolua: embedded Lua code 1");
   lua_settop(tolua_S, top);
  } /* end of embedded lua code */

 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_spine (lua_State* tolua_S) {
 return tolua_spine_open(tolua_S);
};
#endif

