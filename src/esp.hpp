#pragma once
#include <vector>

struct Vec3 { float x, y, z; };
struct Vec2 { float x, y; };

class ESP {
public:
    static bool enabled;
    static std::vector<Vec2> screenPositions;
    
    static void init();
    static void tick(float screenWidth, float screenHeight);
};
