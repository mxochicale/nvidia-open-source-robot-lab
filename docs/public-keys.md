# ublic keys

* Create public key
```bash
ssh-keygen -o -a 100 -t ed25519 -f "$HOME/.ssh/id_ed25519_ucl" -C "${youruclemail}@ucl.ac.uk" 

#PRESS ENTER FOR THIS LINES
#Enter passphrase (empty for no passphrase): 
#Enter same passphrase again: 
```

* Adding your SSH key to the ssh-agent
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_ucl
```

* Example of the public key `id_ed25519_ucl.pub`
```bash
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPqFD5RXNDQuVimU/1gKD5ZM033Ik9jJ3qzQXeAC346  $[youruclemail]@ucl.ac.uk
```
