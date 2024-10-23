```bash
docker run --detach \
  --hostname vheng.iok.la \
  --publish 443:443 --publish 80:80 --publish 22:22 \
  --name gitlab-up150202 \
  --restart always \
  --volume /home/gitlab/config:/etc/gitlab:Z \
  --volume /home/gitlab/logs:/var/log/gitlab:Z \
  --volume /home/gitlab/data:/var/opt/gitlab:Z \
  --shm-size 256m \
  gitlab/gitlab-ce:15.2.2-ce.0
```

