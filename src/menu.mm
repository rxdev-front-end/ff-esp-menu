#include "imgui.h"
#include "esp.hpp"

void drawMenu() {
    static bool open = true;
    if (!open) return;
    ImGui::SetNextWindowPos(ImVec2(40, 100), ImGuiCond_FirstUseEver);
    ImGui::SetNextWindowSize(ImVec2(220, 120), ImGuiCond_FirstUseEver);
    ImGui::Begin("FF Menu - ollie", &open, ImGuiWindowFlags_NoCollapse);
    
    static bool espOn = false;
    if (ImGui::Checkbox("Enemy ESP", &espOn)) {
        ESP::setEnabled(espOn);
    }
    ImGui::Text("Status: %s", espOn ? "ON" : "OFF");
    ImGui::End();
}
