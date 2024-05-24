FROM alpine:3.20.0
RUN apk add --no-cache bash net-tools chrony tzdata git python3
COPY --from=trajano/alpine-libfaketime /faketime.so /lib/faketime.so
ENV LD_PRELOAD=/lib/faketime.so
ENV FAKETIME="-35d"

# script to configure/startup chrony (ntp)
COPY assets/startup.sh /opt/startup.sh

# ntp port
EXPOSE 123/udp

# let docker know how to test container health
HEALTHCHECK CMD chronyc -n tracking || exit 1

# start chronyd in the foreground
ENTRYPOINT [ "/bin/sh", "/opt/startup.sh" ]