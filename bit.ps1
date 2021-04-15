
function asciiToHex($a){
    $b = $a.ToCharArray();
    Foreach ($element in $b) {$c = $c + "%#x" + [System.String]::Format("{0:X}",
    [System.Convert]::ToUInt32($element)) + ";"}
    return $c
}

function Get-Sha( $text ){
    $hex = asciiToHex($text)
    $stringAsStream = [System.IO.MemoryStream]::new()
    $writer = [System.IO.StreamWriter]::new($stringAsStream)
    $writer.write($hex)
    $writer.Flush()
    $stringAsStream.Position = 0
    $sha= Get-FileHash -InputStream $stringAsStream -Algorithm SHA256| Select-Object Hash
    Write-Host $sha.Hash
    return $sha.Hash
    }

function Get-Mining([string]$block_number, [string]$transactions, [string]$previous_hash, [string]$prefix_zeros){

$prefix_str = '0'*$prefix_zeros
for ($nonce=0; $nonce -lt $max_nonce ; $nonce++)
{
       
    $text = $block_number + $transactions + $previous_hash + "$nonce"
    $new_hash = Get-Sha($text)
    if ($new_hash.StartsWith("$prefix_str")){
        Write-Host "--------------------------------------------------------------------------------"
        Write-Host "Sucessfully solved the problem and mined a bitcoin with nonce value: $nonce"
        Write-Host "--------------------------------------------------------------------------------"

        return $new_hash     
     }
}
Write-Host "Problem is too complicated and non profitable to run on this system"

}

$max_nonce = 10000000000000000000
$transactions="Dhaval->Bhavin->20,Mando->Cara->45"
$difficulty=3
$block_number= 5
$start=Get-Date
#Get-Mining($block_number, $transactions,'0000000xa036944e29568d0cff17edbe038f81208fecf9a66be9a2b8321c6ec7',$difficulty)
$new_hash= Get-Mining("$block_number") ("$transactions") ("0000000xa036944e29568d0cff17edbe038f81208fecf9a66be9a2b8321c6ec7") ("$difficulty")
$end=Get-Date
$time=($end - $start).TotalSeconds
Write-Host "time required to compute the problem is $time"
Write-Host "$new_hash"