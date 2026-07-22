#ifndef GUARD_SKY_CANYON_LEVEL_TASK_H
#define GUARD_SKY_CANYON_LEVEL_TASK_H

#include "global.h"
#include "task.h"
#include "sprite.h"

typedef struct {
    /* 0x00 */ Sprite spring;
    /* 0x30 */ Sprite propeller;
    /* 0x60 */ u16 visibleFlyingSprings;
    /* 0x62 */ u16 visiblePropellers;
} SkyCanyonLevelTask;

Task *CreateLevelTask_SkyCanyon(void);

#endif // GUARD_SKY_CANYON_LEVEL_TASK_H
