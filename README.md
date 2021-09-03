# Yet another CTF docker container.
I needed an ubuntu-20.04 container with a very specific libc version, so took a lot of inspiration from: https://github.com/DuckLL/ctf-box .
The ctf-box container looks out of date, it was using the python2 version of pwntools. So I cobbled together my own version.

Uploading for posterity...

Build the container:
```
docker-compose build
```

Start container with:
```
docker-compose run --rm ctf
```

This will volume mount `../` to `/pwn` in the container. 
