const c = @import("../win32/c.zig").graphics.direct3d12;

pub const CommandQueue = c.ID3D12CommandQueue;
pub const CommandQueueDesc = c.D3D12_COMMAND_QUEUE_DESC;
pub const DescriptorHeap = c.ID3D12DescriptorHeap;
pub const DescriptorHeapDesc = c.D3D12_DESCRIPTOR_HEAP_DESC;
pub const DescriptorHeapType = c.D3D12_DESCRIPTOR_HEAP_TYPE;
pub const Device9 = c.ID3D12Device9;

pub const command_list_type_direct = c.D3D12_COMMAND_LIST_TYPE_DIRECT;
pub const command_queue_priority_normal = c.D3D12_COMMAND_QUEUE_PRIORITY_NORMAL;
pub const command_queue_flag_none = c.D3D12_COMMAND_QUEUE_FLAG_NONE;

pub const iid_command_queue = c.IID_ID3D12CommandQueue;
pub const iid_descriptor_heap = c.IID_ID3D12DescriptorHeap;
pub const iid_device9 = c.IID_ID3D12Device9;

pub const createDevice = c.D3D12CreateDevice;
