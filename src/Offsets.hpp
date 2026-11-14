#pragma once
#include <cstdint>

namespace off {
    // A base do UnityFramework vai ser preenchida no init() via dladdr
    inline uintptr_t Il2CppBase = 0;

    // Ponteiros principais
    inline uintptr_t CurrentMatch        = 0x50;
    inline uintptr_t LocalPlayer         = 0x94;
    inline uintptr_t DictionaryEntities  = 0x68;

    // Player e Avatar
    inline uintptr_t Player_IsDead       = 0x50;
    inline uintptr_t Avatar              = 0xA8;
    inline uintptr_t Avatar_Data_IsTeam  = 0x59; // Pra pular aliados se precisar

    // Câmera e Matriz
    inline uintptr_t FollowCamera        = 0x450;
    inline uintptr_t Camera              = 0x18;
    inline uintptr_t ViewMatrix          = 0xE8;

    // Ossos (Bones)
    namespace bones {
        inline uintptr_t Head            = 0x458;
    }
}
