# Yet another docker container.
Needed an ubuntu-18.04 container with a very specific libc version, so took a lot of inspiration from: https://github.com/DuckLL/ctf-box

Uploading for posterity...

Start container with:
```
docker-compose run --rm ctf
```

This will volume mount `../` to `/pwn` in the container. 
