# Test TripleO

## Steps

1. Deploy a bare metal machine with CentOS 8.
1. SSH into the freshly deployed CentOS machine.
```
ssh cloud-user@$MACHINE
```
1. Install git, vim and tmux
```
sudo yum install -y git vim tmux
```
1. Clone the git repository https://github.com/freyes/test-tripleo in the freshly deployed centos machine.
```
git clone https://github.com/freyes/test-tripleo
```
1. Run the setup.sh script
```
cd test-tripleo
./setup.sh
```
