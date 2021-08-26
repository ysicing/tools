FROM ysicing/debian AS dl

RUN apt update && apt-get install --no-install-recommends --no-install-suggests -y gnupg apt-transport-https ca-certificates procps curl wget 

RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | apt-key add -
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.list | tee /etc/apt/sources.list.d/tailscale.list

RUN apt-get update && apt install tailscale -d -y

FROM ysicing/debian

COPY --from=dl /var/cache/apt/archives/tailscale_* /root/