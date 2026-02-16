{ ... }:

{

systemd.network = {
  enable = true;
};

services.resolved.enable = true;
}
