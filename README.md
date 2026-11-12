<div align="center">

# 🌿 Verdant Theme

**A clean and colorful Oh My Zsh theme.**


</div>

## ✨ About

Verdant is a custom Zsh theme for [Oh My Zsh](https://ohmyz.sh/), designed to give your terminal a clean look with colorful prompt elements.

## 📸 Preview

Here's what Verdant looks like in a real terminal:

![Verdant Theme running in a terminal](assets/preview.png)

## 🚀 Installation


### 0. Requirements

Before installing Verdant, make sure you have **Zsh** and **Oh My Zsh** installed on your system. If you haven't installed Oh My Zsh yet, you can install it using the official installation command:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Once Oh My Zsh is installed, you can proceed with the Verdant theme installation.

### 1. Clone the repository

```bash
git clone git@github.com:HorusExE69/verdant-theme.git
```

### 2. Copy the theme into Oh My Zsh

```bash
mkdir -p ~/.oh-my-zsh/custom/themes
cp verdant-theme/verdant.zsh-theme ~/.oh-my-zsh/custom/themes/
```

### 3. Enable Verdant

Open your `~/.zshrc` file and add:

```bash
ZSH_THEME="verdant"
```

### 4. Reload your shell

```bash
source ~/.zshrc
```

That's it! Verdant is ready to use. 🌱


### 5. Terminal Customization

Please note that Verdant only customizes your **Zsh prompt** (colors, symbols, Git information, etc.). It cannot change your terminal's background, cursor shape, cursor color, font, transparency or window appearance.

These settings depend on your terminal emulator and must be configured separately in its **Preferences / Appearance settings**. For the best experience, we recommend using a dark background, a compatible Nerd Font and a pink & mint-green color palette to match Verdant.