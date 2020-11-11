# spectre-base
## Base image to install Alias wallet into

This repository contains a Dockerfile to create base image which could be used
to install [aliaswalletd](https://github.com/aliascash/alias-wallet) into it. So
with each build of aliaswalletd it is not necessary to rebuild the required
environment again and again.

## Licensing

- SPDX-FileCopyrightText: © 2020 Alias Developers
- SPDX-FileCopyrightText: © 2016 SpectreCoin Developers

SPDX-License-Identifier: MIT

## Facts
* Dedicated user _staker_ with UID 1000 and GID 1000
* Installed packages:
  * ca-certificates
  * mc
  * libqt5webchannel5
  * libtool
  * wget

## How it is build
```
docker build -t aliascash/alias-base:latest .
```

### Using more than one core
If multiple cores available for build, you can pass the amount of cores
to use to the build command:

```
docker build -t aliascash/alias-base:latest --build-arg BUILD_THREADS=12 .
```

Default value is BUILD_THREADS=6