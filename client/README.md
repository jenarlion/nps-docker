## 构建镜像

```
docker buildx build --platform linux/arm64,linux/amd64 -t lihaixin/nps:client . --push

docker buildx build --platform linux/amd64 -t lihaixin/nps:client . --push
```
