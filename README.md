```bash
host $ docker pull mipnw/golang:1.15-alpine3.12 # or make build
$ make shell

devbox:golang $ # or whatever prompt you have on your host, same in docker

devbox:golang $ alias
alias ll='ls -l color=auto' # or whatver aliases you have on your host, same in docker

devbox:golang $ id -u; id -g
1234 # same user id as on your host
500 # same group id as on your host

devbox:golang $ cat /etc/alpine-release 
3.12.0 # this is alpine 3.12

devbox:golang $ go version
go version go1.15.2 linux/amd64 # golang 1.15 is installed
```