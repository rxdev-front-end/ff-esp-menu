#include "esp.hpp"
#include "imgui.h"

bool ESP::_enabled = false;
void ESP::setEnabled(bool en) { _enabled = en; }
bool ESP::isEnabled() { return _enabled; }
void ESP::init() {}

void ESP::tick() {
    if (!_enabled) return;
    ImDrawList* dl = ImGui::GetBackgroundDrawList();
    dl->AddRect(ImVec2(100, 100), ImVec2(200, 200), IM_COL32(255, 0, 0, 255), 0.0f, 0, 2.0f);
    dl->AddText(ImVec2(100, 80), IM_COL32(255, 255, 255, 255), "ESP TESTE - OLLIE");
}
