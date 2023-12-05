#!/bin/bash
#
#  REDD's Quick Interactsh Installer
#    v1.2
#


R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
NC='\033[0m'
CH='\u2714'
X='\u2718'    

req_version="1.21.4"
interactsh_version="latest"

export PATH=$PATH:/usr/local/go/bin

if command -v go &> /dev/null; then
    installed_version=$(go version | awk '{print $3}' | cut -c 3-)
    echo -e "${Y}[-] Installed Version of GO:${NC} $installed_version"
    if [[ "$(printf '%s\n' "$req_version" "$installed_version" | sort -V | head -n1)" == "$installed_version" ]]; then
        echo -e "${G}[${CH}] Correct Version is already installed.${NC}"
    else
        echo -e "${R}[${X}] Installed version is older. Proceeding with installation...${NC}"
        echo -e "${Y}[-] Downloading and installing Go $req_version...${NC}"
        url="https://golang.org/dl/go$req_version.linux-amd64.tar.gz"
        wget "$url"
        tar -C /usr/local -xzf "go$req_version.linux-amd64.tar.gz"
        rm "go$req_version.linux-amd64.tar.gz"
        echo -e "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.bashrc"
        echo -e "export GOPATH=\$HOME/go" >> "$HOME/.bashrc"
        echo -e "export GOBIN=\$GOPATH/bin" >> "$HOME/.bashrc"
        echo -e "export PATH=\$PATH:\$GOPATH/bin" >> "$HOME/.bashrc"
        source "$HOME/.bashrc"
        echo -e "${G}[${CH}] Go $req_version installed successfully.${NC}"
    fi
else
    echo -e "${R}[${X}] Go is not installed. Proceeding with installation...${NC}"
    echo -e "${Y}[-] Downloading and installing Go $req_version...${NC}"
    url="https://golang.org/dl/go$req_version.linux-amd64.tar.gz"
    wget "$url"
    tar -C /usr/local -xzf "go$req_version.linux-amd64.tar.gz"
    rm "go$req_version.linux-amd64.tar.gz"
    echo -e "export PATH=\$PATH:/usr/local/go/bin" >> "$HOME/.bashrc"
    echo -e "export GOPATH=\$HOME/go" >> "$HOME/.bashrc"
    echo -e "export GOBIN=\$GOPATH/bin" >> "$HOME/.bashrc"
    echo -e "export PATH=\$PATH:\$GOPATH/bin" >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
    echo -e "${G}[${CH}] Go $req_version installed successfully.${NC}"
fi

export PATH=$PATH:/usr/local/go/bin

if command -v $HOME/go/bin/interactsh-client -version &> /dev/null; then
    echo -e "${G}[${CH}] Interactsh Client already installed.${NC}"
else
    toggle="1"
    echo -e "${R}[${X}] Interactsh Client is not installed.${NC}"
    echo -e "${Y}[-] Attempting to install $interactsh_version version of Interactsh Client...${NC}"
    go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@$interactsh_version
    source $HOME/.bashrc
fi
if [ $# -eq 0 ]; then
    go_passthru="interactsh-client"
else
    go_passthru="interactsh-client $@"
fi

echo -e "$\n\n${NC}[${CH}] Script Done. Starting command: ${R}${go_passthru}${NC}"
$HOME/go/bin/$go_passthru
if [ $toggle -eq "1" ]; then
    clear
    echo -e "\n\n\nEither logout and login or type the command below to reload your profile to allow use of new commands:"
    echo -e "\n\n  ${Y}source \$HOME/.bashrc\n${NC}"
fi
