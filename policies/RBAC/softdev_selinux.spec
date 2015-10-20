# vim: sw=4:ts=4:et

%define selinux_policyver 3.13.1-23

Name:       softdev_selinux
Version:	0.2
Release:	2%{?dist}
Summary:	SELinux policy module for softdev

Group:	    System Environment/Base		
License:	ICS
URL:		https://github.com/Jeroen0494/SELinuxPolicies/

Source0:	softdev.pp
Source1:	softdev.if
Source2:	softdev_selinux.8
Source3:	softdev_u

Requires: policycoreutils, libselinux-utils
Requires(post): selinux-policy-base >= %{selinux_policyver}, policycoreutils
Requires(postun): policycoreutils
BuildArch: noarch

%description
This package installs and sets up the  SELinux policy security module for softdev.

%install
install -d %{buildroot}%{_datadir}/selinux/packages
install -m 644 %{SOURCE0} %{buildroot}%{_datadir}/selinux/packages
install -d %{buildroot}%{_datadir}/selinux/devel/include/contrib
install -m 644 %{SOURCE1} %{buildroot}%{_datadir}/selinux/devel/include/contrib/
install -d %{buildroot}%{_mandir}/man8/
install -m 644 %{SOURCE2} %{buildroot}%{_mandir}/man8/softdev_selinux.8
install -d %{buildroot}/etc/selinux/targeted/contexts/users/
install -m 644 %{SOURCE3} %{buildroot}/etc/selinux/targeted/contexts/users/softdev_u 

%post
semodule -n -i %{_datadir}/selinux/packages/softdev.pp
if /usr/sbin/selinuxenabled ; then
    /usr/sbin/load_policy
    
    /usr/sbin/semanage user -a -R softdev_r softdev_u
fi;
exit 0

%postun
if [ $1 -eq 0 ]; then
    semodule -n -r softdev
    if /usr/sbin/selinuxenabled ; then
       /usr/sbin/load_policy
       
       /usr/sbin/semanage user -d softdev_u
    fi;
fi;
exit 0

%files
%attr(0600,root,root) %{_datadir}/selinux/packages/softdev.pp
%{_datadir}/selinux/devel/include/contrib/softdev.if
%{_mandir}/man8/softdev_selinux.8.*
/etc/selinux/targeted/contexts/users/softdev_u 

%changelog
* Tue Oct 20 2015 Jeroen Rijken <Jeroen.Rijken@nl.thalesgroup.com> 0.2-2
- Update softdev.sh and softdev.fc to use proper file path
* Tue Oct 20 2015 Jeroen Rijken <Jeroen.Rijken@nl.thalesgroup.com> 0.2-1
- Included additional permissions
* Mon Oct 19 2015 Jeroen Rijken <Jeroen.Rijken@nl.thalesgroup.com> 0.1-1
- Initial version

