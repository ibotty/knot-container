FROM centos:7
MAINTAINER Tobias Florek tob@butter.sh

EXPOSE 53535/tcp 53535/udp

ADD knot.conf /etc/knot/knot.conf

RUN set -x \
 && rpmkeys --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
 && yum --setopt=tsflags=nodocs -y install epel-release \
 && rpmkeys --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 \
 && yum --setopt=tsflags=nodocs -y install knot knot-utils \
 && yum clean all \
 && echo '>>> checking knot uid' \
 && test "$(id -u knot)" = 999 \
 && echo '>>> fixing permissions' \
 && for d in /etc/knot /var/lib/knot /var/run/knot; do \
        chmod -R a+rwX "$d"; \
    done

USER 999

CMD ["/usr/sbin/knotd"]
VOLUME ["/etc/knot", "/var/lib/knot"]
