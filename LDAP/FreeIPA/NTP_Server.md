 NTP Server

Kerberos protocol is very sensitive to proper time synchronization between KDC and authentication nodes. With time difference more than several minutes, authentication will not work. For this reason, the server installers configure NTP server (ntpd at the moment) on every FreeIPA server.
Known NTP services

Client and server installers detect 2 time synchronization services - ntpd and chrony. While on the FreeIPA server ntpd is required as chrony only provides NTP client services, the Client accepts already configured chrony. In future versions, chronyd configuration should be preferred. 