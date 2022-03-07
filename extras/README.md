# Squid Proxy

You can start up a squid proxy with.

```
vagrant up squid
```

Once it is up, you can ssh in and exec into the container to watch the logs.

```
vagrant ssh squid
sudo docker ps
sudo docker exec -it <container-id> sh
cd /var/log/squid/
tail -f access.log
```