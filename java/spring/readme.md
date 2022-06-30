# build and run
```sh
# for running and (dev)
docker run -it --rm -v ${PWD}:/work -p 8080:8080 -w /work spring-web-app sh

# for (prod)
docker run --rm -p 8080:8080 spring-web-app
```