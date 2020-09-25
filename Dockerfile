FROM node:8 as builder
WORKDIR /workspace
COPY . .
RUN npm install

FROM node:8-alpine
WORKDIR /workspace
COPY --from=builder /workspace .

RUN set -x \
	    && apk update && apk add ca-certificates wget \
	    && wget -O /workspace/bitcoinrand-daemon-linux.tar.gz "https://github.com/bitcoinrand/bitcoinrand/releases/download/V1.0.0/bitcoinrand-daemon-linux.tar.gz"

RUN set -x \
		&& tar xzvf /workspace/bitcoinrand-daemon-linux.tar.gz \
	    && mkdir /root/.bitcoinrand \
	    && mv /workspace/* /root/.bitcoinrand/ \
		&& chmod +x /root/.bitcoinrand/* \
        && apk del wget ca-certificates

COPY bin/bitcoinrand.conf /root/.bitcoinrand

EXPOSE 3002 19451
CMD "/root/.bitcoinrand/bitcoinrandd -daemon && npm start"