# Port Forwarding Configuration

Port forwarding configuration using `pf` is based on the guide from
[Port Forwarding in Mavericks][1].
This configuration will forward connections from port 127.0.0.1:80 to 127.0.0.1:8080
where is the Apache 2.4 running.


## 1. Port forwarding configuration file

File `pf-apache.conf` loads anchor file with port forwarding rules.
This file must be copied by `sudo` to `/etc`.

```
sudo cp pf-apache.conf /etc/pf-apache.conf
```

## 2. Anchor file with forwarding rule

Anchor file `org.apache.apache24.conf` must be copied by `sudo` to
anchor files location at `/etc/pf.anchors`

```
sudo cp org.apache.apache24.conf /etc/pf.anchors/org.apache.apache24.conf
```

## 3. Launch daemon

System launch daemon ensures to load PF configuration at system startup.

```
sudo cp org.apache.apache24.pfctl.plist /Library/LaunchDaemons/org.apache.apache24.pfctl.plist

sudo launchctl load -w /Library/LaunchDaemons/org.apache.apache24.pfctl.plist
```


[1]: https://gist.github.com/kujohn/7209628