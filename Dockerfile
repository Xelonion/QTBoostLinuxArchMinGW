FROM archlinux/archlinux:base-20230514.0.150299

RUN pacman-key --init \
    && pacman-key --populate \
    && pacman -Sy \
    && pacman -Su --noconfirm --noprogressbar archlinux-keyring pacman \
    && pacman-db-upgrade \
    && pacman -Su --noconfirm --noprogressbar ca-certificates \
    && trust extract-compat \
    && pacman -Syyu --noconfirm --noprogressbar \
    && (echo -e "y\ny\n" | pacman -Scc)

RUN  echo "[ownstuff]" >> /etc/pacman.conf \
    && echo "Server = https://martchus.no-ip.biz/repo/arch/\$repo/os/\$arch " >> /etc/pacman.conf \
    && pacman-key --recv-keys B9E36A7275FC61B464B67907E06FE8F53CDC6A4C \
    && pacman-key --finger    B9E36A7275FC61B464B67907E06FE8F53CDC6A4C \
    && pacman-key --lsign-key B9E36A7275FC61B464B67907E06FE8F53CDC6A4C \
    && pacman -Sy

RUN pacman -S --noconfirm --noprogressbar \
    git make zip 
    
RUN pacman -S --noconfirm --noprogressbar mingw-w64-toolchain \
    mingw-w64-winpthreads \
    mingw-w64-binutils \
    mingw-w64-cmake 
    nsis \
    mingw-w64-boost \
    mingw-w64-qt5 \
    mingw-w64-tools \
    mingw-w64-qt5-base && \
    (echo -e "y\ny\n" | pacman -S mingw-w64-binutils )


# Create symbolic link for windeployqt
RUN ln -s /usr/x86_64-w64-mingw32/lib/qt/bin/windeployqt /usr/bin/windeployqt 

