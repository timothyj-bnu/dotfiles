# .zshrc 

1. exa

- Check the official website: [Official website](https://the.exa.website/) 
- Brew installation (yes it is deprecated now :(): [Brew](https://formulae.brew.sh/formula/exa)
```sh
brew install exa
```

2. Oh My Zsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

3. Plugins

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```

# .config/nvim

Mostly these configs are copied from Prime's config:

[ThePrimeagen/init.lua](https://github.com/ThePrimeagen/init.lua)

1. Packer: Neovim PLugin Manager

Yes it is currently unmaintained, maybe I will change to lazy.nvim in the future.
