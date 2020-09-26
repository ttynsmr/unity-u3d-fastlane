FROM ruby

RUN apt-get update && apt-get -y install tzdata

RUN apt-get -y install \
    # for u3d \
    gconf-service \
    lib32gcc1 \
    lib32stdc++6 \
    libasound2 \
    libc6 \
    libc6-i386 \
    libcairo2 \
    libcap2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libfreetype6 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libglu1-mesa \
    libgtk2.0-0 \
    libnspr4 \
    libnss3 \
    libpango1.0-0 \
    libstdc++6 \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    zlib1g \
    debconf \
    npm \
    libpq5 \
    # lack of things for u3d \
    libgtk-3-0 \
    cpio \
    # for u3d Unity Package \
    p7zip-full \
    # for Unity runtime \
    xvfb \
    # supress locale warnings \
    locales \
    # cleanup \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN gem install -N \
    bundler \
    fastlane \
    u3d

# patch for Unity 2020.x
COPY docker-assets/installation.fixed.rb /usr/local/bundle/gems/u3d-1.2.3/lib/u3d/installation.rb

RUN USER=root u3d available --operating_system linux --force --no-central

ARG UNITY_VERSION=2020.1.4f1
ARG UNITY_MODULES=mac-mono

RUN USER=root u3d install --trace ${UNITY_VERSION} --packages unity,${UNITY_MODULES} && rm -rf /root/Downloads

RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN localedef -f UTF-8 -i en_US en_US.UTF-8
ENV RUBYOPT -EUTF-8
