FROM node:8 as builder
WORKDIR /workspace
COPY . .
RUN npm install

FROM node:8-alpine
WORKDIR /workspace
COPY --from=builder /workspace .

RUN set -x \
	    && apk update && apk add ca-certificates wget \
	    && wget -O bitcoinrand-daemon-linux.tar.gz "https://github.com/bitcoinrand/bitcoinrand/releases/download/V1.0.0/bitcoinrand-daemon-linux.tar.gz" \
	    && tar xzvf bitcoinrand-daemon-linux.tar.gz /workspace \
	    && mkdir /root/.bitcoinrand \
        && chmod +x /root/.bitcoinrand \
	    && mv /workspace/* /root/.bitcoinrand \
        && apk del wget ca-certificates

COPY bin/bitcoinrand.conf /root/.bitcoinrand
RUN /root/.bitcoinrand/bitcoinrandd -daemon
CMD npm start
EXPOSE 3002 19451