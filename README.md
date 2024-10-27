# template-minecraft

A garnix-compatible repo for deploying your own minecraft server

To get your own minecraft server going:

1) Create a [garnix](https://garnix.io) account if you don't have one yet.
2) Fork this repo.
3) Make sure the garnix GitHub App is enabled on this repo.
4) Update the host name in the server config
  [./hosts/server.nix](https://github.com/p1n3appl3/garnix-minecraft/blob/main/flake.nix).
5) [Optional] Add your public ssh key in
  [./hosts/server.nix](https://github.com/p1n3appl3/garnix-minecraft/blob/main/flake.nix).
  This will allow you to ssh into your deployed host.
6) Push your changes! garnix will build and deploy the package, and make your
   server available in a `garnix.me` domain.

This [RSS Bridge Server](https://server.main.template-rss-bridge.garnix-io.garnix.me) gets deployed
automatically with this repository.
