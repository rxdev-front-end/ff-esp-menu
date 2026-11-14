#pragma once
#include <cstdint>
struct Vec3 { float x, y, z; };
struct Vec2 { float x, y; };
class ESP {
public:
    static void setEnabled(bool en);
    static bool isEnabled();
    static void tick();
    static void init();
private:
    static bool _enabled;
};
