# minecraft-docker

Build & Run It
---------------

```bash
docker build --tag bdemers/minecraft-server . 
# or whatever tag you like

docker run -ti -p 25565:25565 -p 25564:25564 -e SERVER_PASS:<new_password_here>  bdemers/minecraft-server
```
