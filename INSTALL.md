INSTALLATION INSTRUCTIONS
-------------------------

1. Uncompress the cyverse-cli.tgz file

```
tar xf cyverse-cli.tgz
```

2. Move the cyverse-cli directory to your preferred installation location

```
mv cyverse-cli $HOME
```

3. Edit ```~/.bashrc``` to add ```cyverse-cli/bin``` to your ```$PATH```

Example:

```
echo "PATH=\$PATH:\$HOME/cyverse-cli/bin" >> ~/.bashrc
```

4. Reload your ```.bashrc```

```source ~/.bashrc```

5. Verify that the CLI is available

