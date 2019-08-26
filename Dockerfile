FROM tatsushid/tinycore:10.0-x86_64 AS zfs-build

RUN tce-load -wci bash
RUN tce-load -wci file
RUN tce-load -wci squashfs-tool
RUN tce-load -wci openssl
RUN tce-load -wci openssl-dev
RUN tce-load -wci libxml2-dev
RUN tce-load -wci libxslt-dev
RUN tce-load -wci perl5
RUN tce-load -wci python3.6-dev
RUN tce-load -wci tcl8.6-dev
RUN tce-load -wci gettext
RUN tce-load -wci tzdata
RUN tce-load -wci gcc
RUN tce-load -wci compiletc
RUN tce-load -wci readline-dev
RUN tce-load -wci cmake
RUN tce-load -wci git
RUN tce-load -wci elfutils-dev
RUN tce-load -wci linux-kernel-sources-env
RUN tce-load -wci libtool
RUN tce-load -wci libtool-dev
RUN tce-load -wci coreutils
RUN tce-load -wci gzip
RUN tce-load -wci rpm
RUN tce-load -wci rpm-dev

RUN sudo sed -i 's/kerver=\$(uname -r)/kerver=4.19.10-tinycore64/g' /usr/local/bin/linux-kernel-sources-env.sh && \
    sudo cliorx linux-kernel-sources-env.sh && \
    sudo ln -s /usr/local/bin/python3 /usr/bin/python3 && \
    sudo ln -s /usr/local/bin/perl /usr/bin/perl
