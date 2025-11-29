#!/bin/bash
growpart /dev/nvme0n1 4
lvextend -L +30G /dev/mapper/RootVG-varVol
xfs_growfs /var