# "Basic" packages
sudo pacman -Syu --noconfirm neovim git nodejs fzf ripgrep zsh starship exa which python3 python-pip

# Config neovim
mkdir ~/.config
git clone https://github.com/mluna711/olivia.git ~/.config/nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
pip3 install neovim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Config zsh
sudo chsh -s $(which zsh) vagrant
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp ~/.config/nvim/.zshrc ~
cp ~/.config/nvim/starship.toml ~/.config
