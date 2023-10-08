# .zshrc 

## exa

- Check the official website: [Official website](https://the.exa.website/) 
- Brew installation (yes it is deprecated now): [Brew](https://formulae.brew.sh/formula/exa)

Example in brew:
```sh
brew install exa
```

## Oh My Zsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Plugins

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
```

# .config/nvim

Mostly these configs are copied from Prime's config: [ThePrimeagen/init.lua](https://github.com/ThePrimeagen/init.lua)

## Neovim (duh)

- Check the official website: [Official website](https://neovim.io/)
- Brew installation: [Brew](https://formulae.brew.sh/formula/neovim)

Example in brew:
```sh
brew install neovim
```

## Packer: Neovim Plugin Manager

Check the repository: [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim) PS: Yes it is currently unmaintained, maybe I will change to lazy.nvim in the future.

Installation
```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Sync the package
```sh
:so
:PackerSync
```

### jdtls

For running jdtls, there are some configurations needed to be changed to get it up and running for me. If you have other way to do this correctly please let me know. Yes most of the paths (if not all) are still absolute path, i'm despreate because it's consuming my sprint velocity to set this up please help.

#### Java 17+

```sh
brew install openjdk@17
```

#### Python 3.9

```sh
brew install python@3.9
```

#### jdtls.py

My edited `jdtls.py` from `.../nvim/mason/packages/jdtls/bin`. All original code belongs to the respective owner. This snippet only for helping me remember what config I changed to get jdtls working.

```py
###############################################################################
# Copyright (c) 2022 Marc Schreiber and others.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
# Marc Schreiber - initial API and implementation
###############################################################################

...

def get_java_executable(validate_java_version):
	java_executable = '/usr/local/opt/openjdk@17/bin/java'

	if 'JAVA_HOME_17' in os.environ:
		java_exec_to_test = Path(os.environ['JAVA_HOME_17']) / 'bin' / 'java'
		if java_exec_to_test.is_file():
			java_executable = java_exec_to_test.resolve()

	if not validate_java_version:
		return java_executable

	out = subprocess.check_output([java_executable, '-version'], stderr = subprocess.STDOUT, universal_newlines=True)

	matches = re.finditer(r"(?<=version\s\")(?P<major>\d+)(\.\d+\.\d+(_\d+)?)?", out)
	for match in matches:
		java_major_version = int(match.group("major"))

		if java_major_version < 17:
			raise Exception("jdtls requires at least Java 17")

		return java_executable

	raise Exception("Could not determine Java version")

...

def main(args):

    ...

	system = platform.system()
	exec_args = ["-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dosgi.checkConfiguration=true",
			"-Dosgi.sharedConfiguration.area=" + str(shared_config_path),
			"-Dosgi.sharedConfiguration.area.readOnly=true",
			"-Dosgi.configuration.cascaded=true",
			"-Xms1G",
			"-javaagent:/Users/juliant/.local/share/nvim/mason/packages/jdtls/lombok.jar",
			"--add-modules=ALL-SYSTEM",
			"--add-opens", "java.base/java.util=ALL-UNNAMED",
			"--add-opens", "java.base/java.lang=ALL-UNNAMED"] \
			+ known_args.jvm_arg \
			+ ["-jar", jar_path,
			"-data", known_args.data] \
			+ args

	if os.name == 'posix':
		os.execvp(java_executable, exec_args)
	else:
		subprocess.run([java_executable] + exec_args)
```


