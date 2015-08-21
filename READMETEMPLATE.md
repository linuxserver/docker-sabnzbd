![http://linuxserver.io](http://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](http://linuxserver.io) team brings you another quality container release featuring auto-update on startup, easy user mapping and community support. Be sure to checkout our [forums](http://forum.linuxserver.io) or for real-time support our [IRC](http://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`.

# linuxserver/sabnzbd

SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction. http://sabnzbd.org/

## Usage

```
docker create --name=sabnzbd -v /etc/localtime:/etc/localtime:ro -v <path to data>:/config -v <path to downloads>:/downloads -v <path to incomplete downloads>:/incomplete-downloads -e PGID=<gid> -e PUID=<uid>  -p 8080:8080 -p 9090:9090 linuxserver/<container-name>
```

**Parameters**

* `-p 8080` - http port for the webui
* `-p 9090` - https port for the webui *see note below*
* `-v /etc/localhost` for timesync - *optional*
* `-v /config` - local path for sabnzbd config files
* `-v /downloads` local path for finished downloads
* `-v /incomplete-downloads` local path for incomplete-downloads - *optional*
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on phusion-baseimage with ssh removed, for shell access whilst the container is running do `docker exec -it sabnzbd /bin/bash`.

### User / Group Identifiers

**TL;DR** - The `PGID` and `PUID` values set the user / group you'd like your container to 'run as' to the host OS. This can be a user you've created or even root (not recommended).

Part of what makes our containers work so well is by allowing you to specify your own `PUID` and `PGID`. This avoids nasty permissions errors with relation to data volumes (`-v` flags). When an application is installed on the host OS it is normally added to the common group called users, Docker apps due to the nature of the technology can't be added to this group. So we added this feature to let you easily choose when running your containers.

## Setting up the application 

<Insert a basic user guide here to get a n00b up and running with the software inside the container.> DELETE ME


## Updates

* Upgrade to the latest version simply `docker restart sabnzbd`.
* To monitor the logs of the container in realtime `docker logs -f sabnzbd`.



## Versions

+ **21.08.2015:** Intial Release. 
