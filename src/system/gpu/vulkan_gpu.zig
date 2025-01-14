const builtin = @import("builtin");
const std = @import("std");

const vulkan = @import("../../bindings.zig").vulkan;
const App = @import("../app.zig").App;
const Gpu = @import("../gpu.zig").Gpu;
const Window = @import("../window.zig").Window;

/// A Vulkan implementation of the Manatee `GPU` interface.
///
/// This handles the implementation of Vulkan for targets that natively support Vulkan (including
/// Windows, most Linux distributions, most BSD distributions, and Nintendo Switch), as well as
/// targets that require the MoltenVK adapter, such as MacOS and iOS.
///
/// Most of this implementation was built directly based off of the Vulkan Guide, with a notable
/// exception to the `init` struct method. In the guide, they used the C++ wrapper `vk-bootstrap`
/// to reduce the amount of verbosity required to set up Vulkan. Since we're using Zig, we don't
/// have that luxury, so we had to effectively rewrite that wrapper inside of this struct's `init`
/// method.
///
/// Most of this will probably need to be re-organized / abstracted in some way or another as I get
/// more comfortable with Vulkan, but that's okay, we're still a LONG way out from v0 anyway!
///
/// A good portion of this implementation was inspired by spanzeri's `vkguide-zig` repo. I'd like
/// to give a huge shout-out to his work as it dramatically helped with my own understanding of how
/// Vulkan (and other external dynamic libraries) can be used within Zig.
pub const VulkanGpu = struct {
    allocator: std.mem.Allocator,
    device: *vulkan.Device,
    framebuffers: []*vulkan.Framebuffer,
    graphics_pipeline: *vulkan.Pipeline,
    image_views: []*vulkan.ImageView,
    instance: *vulkan.Instance,
    pipeline_layout: *vulkan.PipelineLayout,
    queue_graphics: *vulkan.Queue,
    queue_present: *vulkan.Queue,
    render_pass: *vulkan.RenderPass,
    surface: *vulkan.SurfaceKhr,
    swapchain: *vulkan.SwapchainKhr,

    pub fn init(allocator: std.mem.Allocator, app: *const App, window: *Window) !VulkanGpu {
        // Create Instance
        const app_info = vulkan.ApplicationInfo{
            .api_version = vulkan.api_version_1_0,
            .application_name = "Manatee Game",
            .application_version = vulkan.makeApiVersion(0, 0, 1, 0),
            .engine_name = "Manatee",
            .engine_version = vulkan.makeApiVersion(0, 0, 1, 0),
        };
        const instance_extensions: []const [*:0]const u8 = switch (builtin.target.os.tag) {
            .macos => &.{
                "VK_KHR_surface",
                "VK_KHR_get_physical_device_properties2",
                "VK_EXT_metal_surface",
            },
            .windows => &.{
                "VK_KHR_surface",
                "VK_KHR_win32_surface",
            },
            else => &.{},
        };
        const instance_create_info = vulkan.InstanceCreateInfo{
            .enabled_layer_count = 0,
            .application_info = &app_info,
            .extension_names = instance_extensions.ptr,
            .enabled_extension_count = @intCast(instance_extensions.len),
            // TODO: Figure out if this only ever needs to be loaded on MacOS?
            .flags = vulkan.InstanceCreateFlags{ .enumerate_portability_bit_khr = true },
        };
        const instance = try vulkan.Instance.init(&instance_create_info);

        // Create Surface
        const surface = try vulkan.SurfaceKhr.init(instance, app.getNativeApp(), window.getNativeWindow());

        // Determine the Best Physical Device
        const physical_devices = try instance.enumeratePhysicalDevices(allocator);
        defer allocator.free(physical_devices);

        var best_physical_device: ?ManateePhysicalDevice = null;
        var best_physical_device_score: u32 = 0;

        for (physical_devices) |physical_device| {
            const manatee_physical_device = try ManateePhysicalDevice.init(allocator, physical_device, surface, window);

            if (manatee_physical_device.score > best_physical_device_score) {
                best_physical_device = manatee_physical_device;
                best_physical_device_score = manatee_physical_device.score;
            }
        }

        if (best_physical_device == null) {
            return error.no_suitable_physical_device;
        }

        const physical_device = best_physical_device.?;

        // Create Queues
        const queue_priorities: [1]f32 = .{1.0};
        const is_queue_shared = physical_device.queue_family_index_graphics == physical_device.queue_family_index_present;

        const queue_create_infos: [2]vulkan.DeviceQueueCreateInfo = .{
            vulkan.DeviceQueueCreateInfo{
                .queue_count = 1,
                .queue_family_index = physical_device.queue_family_index_graphics,
                .queue_priorities = &queue_priorities,
            },
            vulkan.DeviceQueueCreateInfo{
                .queue_count = 1,
                .queue_family_index = physical_device.queue_family_index_present,
                .queue_priorities = &queue_priorities,
            },
        };

        // Create Device
        const device_extensions: []const [*:0]const u8 = switch (builtin.target.os.tag) {
            .macos => &.{
                "VK_KHR_swapchain",
            },
            .windows => &.{
                "VK_KHR_swapchain",
            },
            else => &.{},
        };

        const device_create_info = vulkan.DeviceCreateInfo{
            .queue_create_info_count = if (is_queue_shared) 1 else 2,
            .queue_create_infos = &queue_create_infos,
            .enabled_features = &best_physical_device.?.features,
            .enabled_extension_names = device_extensions.ptr,
            .enabled_extension_count = @intCast(device_extensions.len),
        };
        var device = try vulkan.Device.init(physical_device.device, &device_create_info);

        // Get queues from device
        const queue_graphics = device.getQueue(physical_device.queue_family_index_graphics, 0);
        const queue_present = device.getQueue(physical_device.queue_family_index_present, 0);

        // Create Swapchain
        const swapchain_create_info = vulkan.SwapchainCreateInfoKhr{
            .surface = surface,
            .min_image_count = physical_device.image_count,
            .image_format = physical_device.surface_format.?.format,
            .image_color_space = physical_device.surface_format.?.color_space,
            .image_extent = physical_device.surface_extent,
            .image_array_layers = 1,
            .image_usage = vulkan.ImageUsageFlags.color_attachment_bit,
            .image_sharing_mode = if (is_queue_shared) .exclusive else .concurrent,
            .queue_family_index_count = if (is_queue_shared) 0 else 2,
            .queue_family_indices = if (is_queue_shared) null else &[2]u32{ physical_device.queue_family_index_graphics, physical_device.queue_family_index_present },
            .pre_transform = physical_device.surface_capabilities.current_transform,
            .composite_alpha = vulkan.CompositeAlphaFlagsKhr.opaque_bit_khr,
            .present_mode = physical_device.surface_present_mode,
            .clipped = true,
            .old_swapchain = null,
        };
        const swapchain = try vulkan.SwapchainKhr.init(device, &swapchain_create_info);

        // Get Swapchain Images
        const images = try swapchain.getImagesKhr(allocator, device);
        defer allocator.free(images);
        const swapchain_extent = physical_device.surface_extent;

        const image_views = try allocator.alloc(*vulkan.ImageView, images.len);

        for (images, image_views) |image, *image_view| {
            const image_view_create_info = vulkan.ImageViewCreateInfo{
                .image = image,
                .view_type = .@"2d",
                .format = physical_device.surface_format.?.format,
                .components = .{
                    .r = .identity,
                    .g = .identity,
                    .b = .identity,
                    .a = .identity,
                },
                .subresource_range = .{
                    .aspect_mask = .{ .color_bit_enabled = true },
                    .base_mip_level = 0,
                    .level_count = 1,
                    .base_array_layer = 0,
                    .layer_count = 1,
                },
            };
            image_view.* = try vulkan.ImageView.init(device, &image_view_create_info);
        }

        // Load Shaders
        // TODO: OBVIOUSLY all of this will get pulled out of here, but that'll probably be in a
        // post-ECS world since this giant ass branch is just for creating a single triangle

        const frag_shader_raw align(@alignOf(u32)) = @embedFile("shader.frag").*;
        const frag_shader_create_info = vulkan.ShaderModuleCreateInfo{
            .code_size = frag_shader_raw.len,
            .code = @ptrCast(&frag_shader_raw),
        };
        const frag_shader = try vulkan.ShaderModule.init(device, &frag_shader_create_info);
        defer frag_shader.deinit(device);

        const vert_shader_raw align(@alignOf(u32)) = @embedFile("shader.vert").*;
        const vert_shader_create_info = vulkan.ShaderModuleCreateInfo{
            .code_size = vert_shader_raw.len,
            .code = @ptrCast(&vert_shader_raw),
        };
        const vert_shader = try vulkan.ShaderModule.init(device, &vert_shader_create_info);
        defer vert_shader.deinit(device);

        // Create Shader Stages
        const frag_shader_stage_create_info = vulkan.PipelineShaderStageCreateInfo{
            .stage = .{ .fragment_bit_enabled = true },
            .module = frag_shader,
            .name = "main",
        };

        const vert_shader_stage_create_info = vulkan.PipelineShaderStageCreateInfo{
            .stage = .{ .vertex_bit_enabled = true },
            .module = vert_shader,
            .name = "main",
        };

        // Create Render Pass
        const color_attachment = vulkan.AttachmentDescription{
            .format = physical_device.surface_format.?.format,
            .samples = vulkan.SampleCountFlags.one_bit,
            .load_op = .clear,
            .store_op = .store,
            .stencil_load_op = .dont_care,
            .stencil_store_op = .dont_care,
            .initial_layout = .undefined,
            .final_layout = .present_src_khr,
        };

        const color_attachment_reference = vulkan.AttachmentReference{
            .attachment = 0,
            .layout = .color_attachment_optimal,
        };

        const subpass = vulkan.SubpassDescription{
            .pipeline_bind_point = .graphics,
            .color_attachment_count = 1,
            .color_attachments = &.{color_attachment_reference},
        };

        const render_pass_create_info = vulkan.RenderPassCreateInfo{
            .attachment_count = 1,
            .attachments = &.{color_attachment},
            .subpass_count = 1,
            .subpasses = &.{subpass},
        };
        const render_pass = try vulkan.RenderPass.init(device, &render_pass_create_info);

        // Create Pipeline Layout
        const dynamic_states = [_]vulkan.DynamicState{ .viewport, .scissor };
        const dynamic_state_create_info = vulkan.PipelineDynamicStateCreateInfo{
            .dynamic_state_count = dynamic_states.len,
            .dynamic_states = &dynamic_states,
        };

        const vertex_input_state_create_info = vulkan.PipelineVertexInputStateCreateInfo{};

        const input_assembly_state_create_info = vulkan.PipelineInputAssemblyStateCreateInfo{
            .topology = .triangle_list,
            .primitive_restart_enable = false,
        };

        const viewport_state_create_info = vulkan.PipelineViewportStateCreateInfo{
            .viewport_count = 1,
            .scissor_count = 1,
        };

        const rasterization_state_create_info = vulkan.PipelineRasterizationStateCreateInfo{
            .polygon_mode = .fill,
            .line_width = 1.0,
            .cull_mode = vulkan.CullModeFlags.back_bit,
            .front_face = .clockwise,
        };

        const multisample_state_create_info = vulkan.PipelineMultisampleStateCreateInfo{
            .rasterization_samples = vulkan.SampleCountFlags.one_bit,
        };

        const color_blend_attachment_state = [_]vulkan.PipelineColorBlendAttachmentState{};

        const color_blend_state_create_info = vulkan.PipelineColorBlendStateCreateInfo{
            .attachment_count = 1,
            .attachments = &color_blend_attachment_state,
            .blend_constants = &.{ 1.0, 1.0, 1.0, 1.0 },
        };

        const pipeline_layout_create_info = vulkan.PipelineLayoutCreateInfo{};
        const pipeline_layout = try vulkan.PipelineLayout.init(device, &pipeline_layout_create_info);

        // Create Pipeline
        const pipeline_create_info = vulkan.GraphicsPipelineCreateInfo{
            .stage_count = 2,
            .stages = &.{ vert_shader_stage_create_info, frag_shader_stage_create_info },
            .vertex_input_state = &vertex_input_state_create_info,
            .input_assembly_state = &input_assembly_state_create_info,
            .viewport_state = &viewport_state_create_info,
            .rasterization_state = &rasterization_state_create_info,
            .multisample_state = &multisample_state_create_info,
            .depth_stencil_state = null,
            .color_blend_state = &color_blend_state_create_info,
            .dynamic_state = &dynamic_state_create_info,
            .layout = pipeline_layout,
            .subpass = 0,
            .base_pipeline_handle = null,
            .base_pipeline_index = -1,
        };
        const graphics_pipeline = try vulkan.Pipeline.init(allocator, device, null, pipeline_create_info);

        // Create Framebuffers
        const framebuffers = try allocator.alloc(*vulkan.Framebuffer, image_views.len);
        for (0..framebuffers.len) |idx| {
            const attachments = [1]*vulkan.ImageView{image_views[idx]};
            const framebuffer_create_info = vulkan.FramebufferCreateInfo{
                .render_pass = render_pass,
                .attachment_count = attachments.len,
                .attachments = &attachments,
                .width = swapchain_extent.width,
                .height = swapchain_extent.height,
                .layers = 1,
            };
            framebuffers[idx] = try vulkan.Framebuffer.init(device, &framebuffer_create_info);
        }

        return VulkanGpu{
            .allocator = allocator,
            .device = device,
            .framebuffers = framebuffers,
            .graphics_pipeline = graphics_pipeline,
            .image_views = image_views,
            .instance = instance,
            .pipeline_layout = pipeline_layout,
            .queue_graphics = queue_graphics,
            .queue_present = queue_present,
            .render_pass = render_pass,
            .surface = surface,
            .swapchain = swapchain,
        };
    }

    pub fn gpu(self: *VulkanGpu) Gpu {
        return Gpu{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Gpu.VTable{
        .deinit = &deinit,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *VulkanGpu = @ptrCast(@alignCast(ctx));
        for (self.framebuffers) |framebuffer| {
            framebuffer.deinit(self.device);
        }
        self.graphics_pipeline.deinit(self.device);
        self.pipeline_layout.deinit(self.device);
        self.render_pass.deinit(self.device);
        for (self.image_views) |image_view| {
            image_view.deinit(self.device);
        }
        self.swapchain.deinit(self.device);
        self.device.deinit();
        self.surface.deinit(self.instance);
        self.instance.deinit();
        self.allocator.destroy(self);
        std.debug.print("Vulkan Cleanup Successful, thanks for playing!\n", .{});
    }
};

/// A Manatee-specific struct that contains a Vulkan Physical Device handle, as well as its
/// features, properties, relevant queue indices, and a score used for picking the best device
///
/// TODO: A good chunk of this should probably be abstracted into something that's not this struct,
/// but I'll get to do that in a post-tutorial world
const ManateePhysicalDevice = struct {
    const Self = @This();
    device: *vulkan.PhysicalDevice,
    features: vulkan.PhysicalDeviceFeatures,
    image_count: u32,
    properties: vulkan.PhysicalDeviceProperties,
    queue_family_index_graphics: u32,
    queue_family_index_present: u32,
    score: u32,
    surface_capabilities: vulkan.SurfaceCapabilitiesKhr,
    surface_extent: vulkan.Extent2d,
    surface_format: ?vulkan.SurfaceFormatKhr,
    surface_present_mode: vulkan.PresentModeKhr,

    pub fn init(allocator: std.mem.Allocator, physical_device: *vulkan.PhysicalDevice, surface: *vulkan.SurfaceKhr, window: *Window) !Self {
        const invalid_queue_family_index = std.math.maxInt(u32);

        const features = physical_device.getFeatures();
        const properties = physical_device.getProperties();

        const surface_formats = try physical_device.getSurfaceFormatsKhr(allocator, surface);
        defer allocator.free(surface_formats);

        const surface_capabilities = try physical_device.getSurfaceCapabilitiesKhr(surface);

        const surface_present_modes = try physical_device.getSurfacePresentModesKhr(allocator, surface);
        defer allocator.free(surface_present_modes);

        const queue_family_properties = try physical_device.getQueueFamilyProperties(allocator);
        defer allocator.free(queue_family_properties);

        var queue_family_index_graphics: u32 = invalid_queue_family_index;
        var queue_family_index_present: u32 = invalid_queue_family_index;

        for (queue_family_properties, 0..) |queue_family, idx| {
            // Set graphics queue family index
            if (queue_family_index_graphics == invalid_queue_family_index) {
                const has_graphics_support = @as(u32, @bitCast(queue_family.queue_flags)) & @as(u32, @bitCast(vulkan.QueueFlagBits.graphics_bit)) != 0;
                if (has_graphics_support) {
                    queue_family_index_graphics = @intCast(idx);
                }
            }

            // Set present queue family index
            if (queue_family_index_present == invalid_queue_family_index) {
                const has_present_support = try physical_device.getSurfaceSupportKhr(@intCast(idx), surface);
                if (has_present_support) {
                    queue_family_index_present = @intCast(idx);
                }
            }
        }

        var score: u32 = 0;
        // Discrete GPUs have a significant performance advantage
        if (properties.device_type == .discrete_gpu) {
            score += 1000;
        }

        // Maximum possible size of textures affects graphics quality
        score += properties.limits.max_image_dimension_2d;

        // We want to heavily discourage use of devices that don't have geometry shader support,
        // however for Apple devices with integrated GPUs (such as M1 MacBooks), their GPU will
        // never support geometry shaders (due to a lack of support in the Metal API), so we'll set
        // the device's score to 1 just to be on the safe side
        if (features.geometry_shader == 0) {
            score = 1;
        }

        // If a device has any invalid queue indexes, we'll set the score to 0 as we can't use a
        // device with incomplete queues
        // if (queue_family_index_graphics == invalid_queue_family_index or queue_family_index_present == invalid_queue_family_index) {
        if (queue_family_index_graphics == invalid_queue_family_index) {
            score = 0;
        }

        if (surface_formats.len == 0 or surface_present_modes.len == 0) {
            score = 0;
        }

        var preferred_surface_format: ?vulkan.SurfaceFormatKhr = null;

        for (surface_formats) |surface_format| {
            if (surface_format.format == .b8g8r8a8_srgb and surface_format.color_space == .srgb_nonlinear_khr) {
                preferred_surface_format = surface_format;
            }
        }

        if (preferred_surface_format == null) {
            preferred_surface_format = surface_formats[0];
        }

        var preferred_surface_present_mode: vulkan.PresentModeKhr = vulkan.PresentModeKhr.fifo_khr;

        for (surface_present_modes) |present_mode| {
            if (present_mode == .mailbox_khr) {
                preferred_surface_present_mode = present_mode;
            }
        }

        const window_dimensions = window.getDimensions();
        const surface_extent: vulkan.Extent2d = if (surface_capabilities.current_extent.width != std.math.maxInt(u32)) surface_capabilities.current_extent else vulkan.Extent2d{
            .width = @max(surface_capabilities.min_image_extent.width, @min(surface_capabilities.max_image_extent.width, window_dimensions.width)),
            .height = @max(surface_capabilities.min_image_extent.height, @min(surface_capabilities.min_image_extent.height, window_dimensions.height)),
        };

        var image_count: u32 = surface_capabilities.min_image_count + 1;
        if (surface_capabilities.max_image_count > 0 and image_count > surface_capabilities.max_image_count) {
            image_count = surface_capabilities.max_image_count;
        }

        return Self{
            .device = physical_device,
            .features = features,
            .image_count = image_count,
            .properties = properties,
            .queue_family_index_graphics = queue_family_index_graphics,
            .queue_family_index_present = queue_family_index_present,
            .score = score,
            .surface_capabilities = surface_capabilities,
            .surface_extent = surface_extent,
            .surface_format = preferred_surface_format,
            .surface_present_mode = preferred_surface_present_mode,
        };
    }
};
