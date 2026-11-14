#include "esp.hpp"
#include "Offsets.hpp"
#include <dlfcn.h>
#include <cmath>

bool ESP::enabled = false;
std::vector<Vec2> ESP::screenPositions;

bool isValidPtr(uintptr_t ptr) {
    if (ptr == 0) return false;
    if (ptr < 0x100000000) return false; 
    if (ptr > 0x200000000) return false; 
    if (ptr % 8 != 0) return false;      
    return true;
}

template<typename T> T safe_read(uintptr_t addr) {
    if (!isValidPtr(addr)) return T{};
    return *(T*)addr;
}

static bool worldToScreen(Vec3 pos, Vec2* out, float* matrix, float width, float height) {
    float w = matrix[3] * pos.x + matrix[7] * pos.y + matrix[11] * pos.z + matrix[15];
    if (w < 0.001f) return false;

    float x = (matrix[0] * pos.x + matrix[4] * pos.y + matrix[8] * pos.z + matrix[12]) / w;
    float y = (matrix[1] * pos.x + matrix[5] * pos.y + matrix[9] * pos.z + matrix[13]) / w;

    out->x = (x * 0.5f + 0.5f) * width;
    out->y = (1.0f - (y * 0.5f + 0.5f)) * height;
    return true;
}

void ESP::init() {
    Dl_info info;
    if (dladdr((void*)&ESP::init, &info)) {
        off::Il2CppBase = (uintptr_t)info.dli_fbase;
    }
}

void ESP::tick(float screenWidth, float screenHeight) {
    screenPositions.clear();
    if (!enabled || !off::Il2CppBase) return;

    uintptr_t match = safe_read<uintptr_t>(off::Il2CppBase + off::CurrentMatch);
    if (!match) return;

    uintptr_t localPlayer = safe_read<uintptr_t>(match + off::LocalPlayer);
    if (!localPlayer) return;

    uintptr_t dict = safe_read<uintptr_t>(match + off::DictionaryEntities);
    if (!dict) return;

    uintptr_t followCam = safe_read<uintptr_t>(localPlayer + off::FollowCamera);
    if (!followCam) return;
    
    uintptr_t cam = safe_read<uintptr_t>(followCam + off::Camera);
    if (!cam) return;

    float* viewMatrix = (float*)(cam + off::ViewMatrix);
    if (!isValidPtr((uintptr_t)viewMatrix)) return;

    uintptr_t entries = safe_read<uintptr_t>(dict + 0x18); 
    int count = safe_read<int>(dict + 0x20);               

    if (isValidPtr(entries) && count > 0 && count < 100) {
        for (int i = 0; i < count; i++) {
            uintptr_t entry = entries + (i * 0x18); 
            if (!isValidPtr(entry)) continue;
            
            uintptr_t player = safe_read<uintptr_t>(entry + 0x10); 
            if (!player || player == localPlayer) continue;
            
            if (safe_read<bool>(player + off::Player_IsDead)) continue;

            uintptr_t avatar = safe_read<uintptr_t>(player + off::Avatar);
            if (!avatar) continue;

            uintptr_t head = safe_read<uintptr_t>(avatar + off::bones::Head);
            if (!head) continue;

            Vec3 headPos = safe_read<Vec3>(head);
            Vec2 screenPos;
            
            if (worldToScreen(headPos, &screenPos, viewMatrix, screenWidth, screenHeight)) {
                screenPositions.push_back(screenPos);
            }
        }
    }
}
