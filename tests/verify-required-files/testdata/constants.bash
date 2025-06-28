# constants for use by this test suite

# PART_MAP_1 matches ebom.good.1.csv
export PART_MAP_1='MOOCOWA,nomad_1.10.1_darwin_amd64.zip
MOOCOWB,nomad_1.10.1_darwin_arm64.zip
MOOCOWC,nomad_1.10.1_linux_amd64.zip
MOOCOWD,nomad_1.10.1_linux_arm64.zip
MOOCOWE,nomad_1.10.1_windows_amd64.zip
MOOCOWF,nomad_linux_amd64_1.10.1.tar
MOOCOWG,nomad_linux_arm64_1.10.1.tar
MOOCOWH,nomad_1.10.1-1_arm64.deb
MOOCOWI,nomad_1.10.1-1_amd64.deb
MOOCOWJ,nomad-1.10.1-1.aarch64.rpm
MOOCOWK,nomad-1.10.1-1.x86_64.rpm
MOOCOWL,Getting Started with IBM Nomad.pdf'

# PART_MAP_2 matches ebom.good.2.csv
export PART_MAP_2='MOOCOW1,nomad_1.10.1_linux_s390x.zip
MOOCOW2,nomad-1.10.1-1.s390x.rpm
MOOCOW3,nomad_1.10.1-1_s390x.deb
MOOCOW4,Getting Started with IBM Nomad for Z.pdf'

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
