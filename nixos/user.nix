{
  users.extraUsers.kreisys = {
    createHome      = true;
    home            = "/home/kreisys";
    description     = "Shay Bergmann";
    extraGroups     = [ "wheel" ];
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDzC4AeW6zvJ3AFRKWMATwrXbbU4V62EzO8lNPYXWpU8AgCbu6VZZB/LVIGC5p9yZd/AZpYTf84XrVnh5r1Vsur6y1UVJKStbR7xmPptyaI/h6O5eUpI+V5i7xCP/Kvw3eOwxxEpfHR4YIHRfD1V6LtpjGhlGe1LCq/Fszo1ihYWCa4RfRgorz2cPrKBKYGbJX0shgSMzG8e32ZRK11A59uQcL5G54FrB3uWu+n/mJIEpnT2f9v/ZBpCUmYH38gijVuJMI8xfzJsqM6hubgxTk1u2X/trt0KfzIuWG1qKJ9GuO18hxJKPPPOXe71sb96KvX99JbMTndr1XuRtDndqGP kreisys@github/6173530 # ssh-import-id gh:kreisys"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8mufrchy0/rJgQmPttXSBSs9Q/1lGRTTb/tVnC0B/Xpih5Q6VXFh9J2PlphHKntFBCc4WtSXNIrdwLIEqxnSPPOOSA/gVSkYGEvlqRUuORnLyDbFCfatwcEiVRrw+hJJneugbvPZww2OJ46H70TkcucLYOoNCHm5sKRe/UY83YD3aDmfNJx5M4O+nfgMyWP+2pjcbOCjmE1fB4bdN4f1zxDtlMT/iXmBqcsji0lvP/USr6IF4i6q4B6Vz9D6a3yv0Z1NiRLFvnlX8CPq512UEmrZDQ4ig9yhPJMBdFhH75RenxqhJ+Du2DzizhM1t7cbY8ceu8zSlZYDQASj6wcSn kreisys@github/26432704 # ssh-import-id gh:kreisys"
    ];
  };
}
