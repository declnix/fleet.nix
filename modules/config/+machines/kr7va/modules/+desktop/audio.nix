{ ... }:
{
  den.aspects.kr7va = {
    provides.declnix.nixos = {
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };

      services.pulseaudio.enable = false;
    };
  };
}
