#!/bin/bash
# scriptDir=$(
#     cd $(dirname $0)
#     pwd
# ) # 脚本路径

# 先安装 oh-my-zsh: https://github.com/ohmyzsh/ohmyzsh
# source ${scriptDir}/install_ohmyzsh.sh

# 配置git
git config --global user.name gogogo
git config --global user.email gogogo.aliyun.com

# 配置 oh my zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/thinkgos/minority.git ~/.minority/minority
mkdir -p ~/.config

ln -s ~/.minority/minority/zellij ~/.config/zellij
ln -s ~/.minority/minority/vim/.vimrc ~/.vimrc
ln -s ~/.minority/minority/zshrc/.zshrc ~/.zshrc
ln -s ~/.minority/minority/zshrc/starship.toml ~/.config/starship.toml
# 安装 rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
# 配置代理
cat >.cargo/config <<EOF
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry="git://mirrors.ustc.edu.cn/crates.io-index"
EOF
# 安装 rust 插件
cargo install starship
cargo install atuin
cargo install zellij
cargo install git-delta
