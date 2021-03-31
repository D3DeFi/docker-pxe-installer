Docker PXE Installer
====================

This aims to be minimal take your PXE installer anywhere project. Be it local notebook in datacenter or just random server in your infrastructure.

Currently defaults to Ubuntu 20.04, but can be easily customized however you need.

This builds a top of amazing work done in https://github.com/ferrarimarco/docker-pxe

Installation
------------

1. have docker installed
2. edit prepare.sh and run it. This will download ISO and create missing files (at least LISTENIP should be changed)
3. edit dnsmasq.conf to your needs (at least dhcp-range= should be modified)
4. edit web/cloud-init-bios/user-data to suit your needs (default file is for the preview. It was generated just by hitting enter, password is Admin123)
5. `docker-compose up -d`
