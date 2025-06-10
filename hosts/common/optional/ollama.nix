{ acceleration ? null, ... }:
{
  services.ollama = {
    enable = true;
    inherit acceleration;
  };
}
