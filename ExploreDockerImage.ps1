Param($Image) 

if(!$Image)
{
    Write-Host "====================================================================================================================="
    Write-Host "No Images Name passed, give path to the IMAGE. Ex: username/imagename:tag" -ForegroundColor DarkYellow
    $Image = Read-Host "Ok, Give me the image name!!" 
    Write-Host "====================================================================================================================="
}

if($Image)
{    
    $ContainerName = ($Image -split ":")[1]

    $ContainerID = docker ps -aqf "name=$ContainerName"
    if($ContainerID)
    {
        Write-Host "====================================================================================================================="
        Write-Host "Container with ID $ContainerID, found locally for the image $Image" 
        Write-Host ""
        Write-Host "Checking Container Status!" 

        if(docker ps -aq --filter "status=exited" --filter "name=ac5418b")
        {
            Write-Host "Ok, this guy is not running. Jump Starting the container" 
            docker start $ContainerID
        }
        else
        {
            Write-Host "Ok, this guy is running. Get Ready to roll"            
        }
    }
    else
    {
        docker run -d --name $ContainerName $Image 
    }
    Write-Host "====================================================================================================================="
    
    Write-Host "All Set, exploring the container. User BASH command to explore file system. Ex: 'ls -a' to list all files"
    Write-Host "Enter 'exit' to stop exploring the container" 

    Write-Host "====================================================================================================================="
    docker exec -t -i $ContainerID /bin/bash 
}
else
{
    Write-Host "No Image Name Passed, aborting operaton" 
}
Pause