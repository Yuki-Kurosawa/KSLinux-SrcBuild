# KSLinux

A Linux Distribution Based on GNU/Linux with Following extra packages:<br/>
dpkg (Debian Package Manager)<br/>
Kuroasawa Package Toolset (KPT) [conflicts: apt]<br/>
Supported Architecture: i386(i686) amd64(x86-64) armhf aarch64(arm64)

dpkg

---------
Install Packages: dpkg -i xxx.deb<br/>
Remove Packages: dpkg -r xxx<br/>
Purge Packages: dpkg -P xxx<br/>
Build Packages via dpkg-deb: dpkg-deb --build /opt/xxx xxx.deb<br/>
<br/>

KPT

---------
Update Package List: kpt update<br/>
Install Packages: kpt install xxx<br/>
Remove Packages: kpt remove xxx<br/>
Purge Packages: kpt purge xxx<br/>
Update Packages: kpt upgrade xxx<br/>

Note for conflicts

---------
You can use dpkg and apt as usual like debian or ubuntu.<br/>
But KSLinux is not based on debian or ubuntu series.<br/>

Build Information

---------
1. Download Source code from:<br/>
http://www.linuxfromscratch.org/lfs/view/stable/<br/>
http://www.linuxfromscratch.org/blfs/view/stable/<br/>
https://www.gnu.org/<br/>
https://packages.debian.org/<br/>
<font color="blue">
**WARNING: Other version not tested**
</font><br/>
2. using these commands to check your enviroment:<br/>
./configure<br/>
it will create makefile if check test complete successfully<br/>
3. Run following command to build<br/>
make<br/>
<font color="red">**ERROR: DO NOT RUN AS ROOT**</font><br/>
<font color="blue">**NOTE: KSLinux has not been compiled completely, please don't use KSLinux in production environments.**</font><br/>
<br/>
Current Status:
Last Compiled: temporary system for building release packages (tmp_system)
Next Compile: zlib1g for temporary system (tmp_system)
