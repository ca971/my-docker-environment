# Prerequisites

## Hypervisor

Choose one:

   - [VMware Fusion](https://www.vmware.com/products/fusion)
   - [Virtualbox](https://www.virtualbox.org)

## Docker

1. Install Docker Toolbox

    - `$ brew cask install dockertoolbox`

    - Note: If you are running VMWare then you must edit the cask and remove the Virtualbox dependency:

    `$ brew cask edit dockertoolbox`

1. Create Docker Machine

    `$ make machine-vmware` or `$ make machine-virtualbox`

1. Update your shell rc, add the following line

    `eval $(docker-machine env default)`

1. Configure local DNS resolver

    `$ make resolver`
