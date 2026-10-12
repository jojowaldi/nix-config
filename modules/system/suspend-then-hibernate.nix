{ ... }:

{
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandleSuspendKey = "suspend-then-hibernate";
    SleepOperation = "suspend-then-hibernate";
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "yes";
    AllowSuspendThenHibernate = "yes";
    HibernateDelaySec = "1h";
    HibernateOnACPower = "yes";
  };
}
