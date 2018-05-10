# dockerbridge

Http/Socket proxy bridge with nginx on alpine.

## Run

```bash
docker run -d --name bridge --network=mynet -p 3306:8081 -p 27017:27017 -p 5601:9000 -e "PROXY_STREAM=mysql:3306:8081;mongo:27017" -e "PROXY_HTTP=kibana:5601:9000" seancheung/dockerbridge:latest
```

## Environments

**PROXY_STREAM**

One or more socket streams to proxy.

```bash
PROXY_STREAM=service_host:service_port
PROXY_STREAM=service_host:service_port:listen_port
PROXY_STREAM=service1_host:service2_port;service2_host:service2_port;
PROXY_STREAM=service1_host:service2_port;service2_host:service2_port:service2_listen_port;
```

**PROXY_HTTP**

One or more http services to proxy.

```bash
PROXY_HTTP=service_host:service_port
PROXY_HTTP=service_host:service_port:listen_port
PROXY_HTTP=service1_host:service2_port;service2_host:service2_port;
PROXY_HTTP=service1_host:service2_port;service2_host:service2_port:service2_listen_port;
```

## Tips

### Open extra ports for an existing container

1. Create a network

```bash
docker network create mynet
```

2. Connect your target container to this network

```bash
docker network connect mycontainer mynet
```

3. Pull and run this image

```bash
docker run -d --name bridge --restart=always -p 3306:3306 -e "PROXY_STREAM=mycontainer:3306" seancheung/dockerbridge:latest
```

#### Open extra ports over this image

1. Destroy old container

```bash
docker stop bridge
docker rm -v bridge
```

2. Create new

```bash
docker run -d --name bridge --restart=always -p 3306:3306 -p 8001:80 -e "PROXY_STREAM=mycontainer:3306" -e "PROXY_HTTP=mycontainer:80" seancheung/dockerbridge:latest
```