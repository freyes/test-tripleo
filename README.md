# Test TripleO

## Steps

1. Deploy a bare metal machine with CentOS 8.
2. SSH into the freshly deployed CentOS machine.
```
ssh cloud-user@$MACHINE
```
3. Install git, vim and tmux
```
sudo yum install -y git vim tmux
```
4. Clone the git repository https://github.com/freyes/test-tripleo in the freshly deployed centos machine.
```
git clone https://github.com/freyes/test-tripleo
```
5. Run the setup.sh script
```
cd test-tripleo
./setup.sh
```
