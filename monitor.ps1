    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "C:\Users\admin\Desktop\AdventNet\ME\ServiceDesk\lib\fix"
    $watcher.Filter = "*.java*"
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true 
    $watcher.NotifyFilter = [System.IO.NotifyFilters]'Size,FileName'
### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = { 
		Clear-Host
                $path = $Event.SourceEventArgs.FullPath
                $A = Start-Process -FilePath mgc_sample.bat $path -NoNewWindow -Wait -passthru;$A.ExitCode
                $B = Start-Process -FilePath CR.bat -Wait -passthru -WindowStyle Hidden;$B.ExitCode
                $logline = "$path"
                Add-content "C:\Users\admin\Desktop\log.txt" -value $logline
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Changed" -Action $action
    while($true){}
    