FROM alpine:3.2
MAINTAINER Oscar Garcia Amor (https://ogarcia.me)

# Install necessary stuff
RUN echo "http://dl-4.alpinelinux.org/alpine/v3.3/main" > /etc/apk/repositories && \
  apk -U --no-progress upgrade && \
  apk -U --no-progress add s6 taskd taskd-pki

# Import build and startup script
COPY docker /app/taskd/

# Set the data location
ENV TASKDDATA /var/taskd

# Configure container
VOLUME ["/var/taskd"]
EXPOSE 53589
ENTRYPOINT ["/app/taskd/run.sh"]
CMD ["/usr/bin/s6-svscan", "/app/taskd/s6/"]
