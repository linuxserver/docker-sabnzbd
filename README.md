![https://linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](https://www.linuxserver.io/) team brings you another quality container release featuring auto-update on startup, easy user mapping and community support. Be sure to checkout our [forums](https://forum.linuxserver.io/index.php) or for real-time support our [IRC](https://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`.

# linuxserver/sabnzbd

SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction. 
This container includes par2 multicore.  http://sabnzbd.org/

## Usage

```
docker create --name=sabnzbd -v /etc/localtime:/etc/localtime:ro -v <path to data>:/config -v <path to downloads>:/downloads -v <path to incomplete downloads>:/incomplete-downloads -e PGID=<gid> -e PUID=<uid>  -p 8080:8080 -p 9090:9090 linuxserver/sabnzbd
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
Initial setup is done from the htpp port.
Https access for sabnzbd needs to be enabled in either the intial setup wizard or in the configure settings of the webui, be sure to use 9090 as port for https.
See here for info on some of the switch settings for sabnzbd http://wiki.sabnzbd.org/configure-switches


## Updates

* Upgrade to the latest version simply `docker restart sabnzbd`.
* To monitor the logs of the container in realtime `docker logs -f sabnzbd`.


## Credits
https://github.com/jcfp/debpkg-par2tbb for the par2 multicore used in this container.

## Versions
+ **23.01.2015:** Refresh image.
+ **14.12.2015:** Refresh image to pick up latest beta
+ **21.08.2015:** Intial Release. 
