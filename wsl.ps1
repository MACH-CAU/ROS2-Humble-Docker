netsh interface portproxy reset

# 165.194.11.20
$addr		= '0.0.0.0'
$port		= '4242'
$remoteaddr = '172.18.135.160'
$remoteport = '4267'

iex "New-NetFireWallRule -DisplayName 'debian' -Direction Outbound -LocalPort $port, $remoteport -Action Allow -Protocol TCP";
iex "New-NetFireWallRule -DisplayName 'debian' -Direction Inbound -LocalPort $port, $remoteport -Action Allow -Protocol TCP";
iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$remoteport connectaddress=$remoteaddr";


netsh interface portproxy show v4tov4
