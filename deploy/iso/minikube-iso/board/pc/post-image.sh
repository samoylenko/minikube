#!/bin/sh

# Copyright 2022 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

echo "2*** post-image.sh"

pwd
ls -lah
echo "BINARIES_DIR $BINARIES_DIR"

UUID=$(dumpe2fs "$BINARIES_DIR/rootfs.ext2" 2>/dev/null | sed -n 's/^Filesystem UUID: *\(.*\)/\1/p')

echo "$UUID"

sed -i "s/UUID_TMP/$UUID/g" "$BINARIES_DIR/efi-part/EFI/BOOT/grub.cfg"

echo "2***b is grub in here?"
ls -lah $BINARIES_DIR/efi-part/EFI/BOOT/
cat $BINARIES_DIR/efi-part/EFI/BOOT/grub.cfg

sed "s/UUID_TMP/$UUID/g" board/pc/genimage-efi.cfg > "$BINARIES_DIR/genimage-efi.cfg"

echo "2***c genimage-efi.cfg"
ls -lah $BINARIES_DIR
cat $BINARIES_DIR/genimage-efi.cfg

support/scripts/genimage.sh -c "$BINARIES_DIR/genimage-efi.cfg"

echo "2***z done"