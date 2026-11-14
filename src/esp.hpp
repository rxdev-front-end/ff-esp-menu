#pragma once
#include <vector>

struct Vec3 { float x, y, z; };
struct Vec2 { float x, y; };

class ESP {
public:
    static bool enabled;
    static void tick();
    static std::vector<Vec2> screenPositions; // Onde o UIKit vai desenhar
};
