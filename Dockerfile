FROM alpine

LABEL maintainer="Tapas Sharma <tapas.bits@gmail.com>"

ARG VCS_REF
ARG BUILD_DATE
## For dockerhub
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/tapas-sharma/kubectl-k8s" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

##In case we do not have one passed in from
## ENV to download
ENV KUBECTL_DEFAULT_VERSION="v1.18.6"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_DEFAULT_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/defkubectl \
 && chmod +x /usr/local/bin/defkubectl \
 && rm /var/cache/apk/*

COPY entrypoint.sh /root/entrypoint.sh
WORKDIR /root
ENTRYPOINT ["sh","/root/entrypoint.sh"]
CMD ["version"]