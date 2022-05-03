## 构建镜像

```
docker buildx build --platform linux/arm64,linux/amd64 -t lihaixin/nps:client . --push

docker buildx build --platform linux/amd64 -t lihaixin/nps:client . --push
```

## 运行

```
docker pull lihaixin/nps:client
docker stop npc  && docker rm npc 
docker run -d \
--name npc \
--restart=always \
--net=host \
-e DOCKERID=FR1VPN \
lihaixin/nps:client
```
