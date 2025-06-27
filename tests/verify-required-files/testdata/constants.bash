# constants for use by this test suite

# PART_MAP_1 matches ebom.good.1.csv
export PART_MAP_1='M0RKNML,nomad_1.10.1_darwin_amd64.zip
M0RKPML,nomad_1.10.1_darwin_arm64.zip
M0RKQML,nomad_1.10.1_linux_amd64.zip
M0RKRML,nomad_1.10.1_linux_arm64.zip
M0RKSML,nomad_1.10.1_windows_amd64.zip
M0RKTML,nomad_linux_amd64_1.10.1.tar
M0RKVML,nomad_linux_arm64_1.10.1.tar
M0RKWML,nomad_1.10.1-1_arm64.deb
M0RKXML,nomad_1.10.1-1_amd64.deb
M0RKYML,nomad-1.10.1-1.aarch64.rpm
M0RKLML,nomad-1.10.1-1.x86_64.rpm
M0RKMML,Getting Started with IBM Nomad.pdf'

# PART_MAP_2 matches ebom.good.2.csv
export PART_MAP_2='M0RKZML,nomad_1.10.1_linux_s390x.zip
M0RL0ML,nomad-1.10.1-1.s390x.rpm
M0RL1ML,nomad_1.10.1-1_s390x.deb
M0RL2ML,Getting Started with IBM Nomad for Z.pdf'

export PART_MAP_NO_GUIDE='M0RKZML,nomad_1.10.1_linux_s390x.zip
M0RL0ML,nomad-1.10.1-1.s390x.rpm
M0RL1ML,nomad_1.10.1-1_s390x.deb'

export PART_MAP_DUPLICATES='M0RKZML,nomad_1.10.1_linux_s390x.zip
M0RL0ML,nomad-1.10.1-1.s390x.rpm
M0RL1ML,nomad_1.10.1-1_s390x.deb
M0RL2ML,Getting Started with IBM Nomad for Z.pdf
M0RL0ML,nomad-1.10.1-1.s390x.rpm
M0RL1ML,nomad_1.10.1-1_s390x.deb'

export PART_MAP_INVALID_PARTS='M,nomad_1.10.1_linux_s390x.zip
m0rl0ml,nomad-1.10.1-1.s390x.rpm
M0RL1ML0,nomad_1.10.1-1_s390x.deb'
