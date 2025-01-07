// I have no idea what ANY of this does but I copied it from the Vulkan tutorial lol. Baby's first
// shader! This felt a LOT easier in UE and Unity, but I assume they had PILES of abstractions over
// directly writing shaders

#version 450

layout(location = 0) in vec3 fragColor;

layout(location = 0) out vec4 outColor;

void main() {
    outColor = vec4(fragColor, 1.0);
}