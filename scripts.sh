#!/bin/bash

echo "installing xclip..."
sudo apt install xclip -y

echo "installing lazydocker"
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
