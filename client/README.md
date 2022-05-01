## 构建镜像

```
docker buildx build --platform linux/arm64,linux/amd64 -t lihaixin/nps:client . --push

docker buildx build --platform linux/amd64 -t lihaixin/nps:client . --push
```

## 运行

```
docker pull lihaixin/nps:client
docker stop npc3  && docker rm npc3 
docker run -d \
--name npc3 \
--restart=always \
--net=host \
-e HELPDOMAIN=youdomain.com \
-e BRIDGE_PORT=8024 \
-e MODE=kcp \
-e PUBLIC_VKEY=12345678 \
-e DOCKERID=FR1VPN \
lihaixin/nps:client
```
