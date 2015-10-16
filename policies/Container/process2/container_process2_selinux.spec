# vim: sw=4:ts=4:et


%define relabel_files() \
restorecon -R ${PWD}container_process2.sh; \

%define selinux_policyver 3.13.1-23

Name:       container_process2_selinux
Version:	1.1
Release:	2%{?dist}
Summary:	SELinux policy module for container_process2

Group:	    System Environment/Base		
License:	ICS
URL:		https://github.com/Jeroen0494/SELinuxPolicies/
Source0:	container_process2.pp
Source1:	container_process2.if
Source2:	container_process2_selinux.8


Requires: policycoreutils, libselinux-utils
Requires(post): selinux-policy-base >= %{selinux_policyver}, policycoreutils
Requires(postun): policycoreutils
BuildArch: noarch

%description
This package installs and sets up the  SELinux policy security module for container process2.

%install
install -d %{buildroot}%{_datadir}/selinux/packages
install -m 644 %{SOURCE0} %{buildroot}%{_datadir}/selinux/packages
install -d %{buildroot}%{_datadir}/selinux/devel/include/contrib
install -m 644 %{SOURCE1} %{buildroot}%{_datadir}/selinux/devel/include/contrib/
install -d %{buildroot}%{_mandir}/man8/
install -m 644 %{SOURCE2} %{buildroot}%{_mandir}/man8/container_process2_selinux.8
install -d %{buildroot}/etc/selinux/targeted/contexts/users/


%post
semodule -n -i %{_datadir}/selinux/packages/container_process2.pp
if /usr/sbin/selinuxenabled ; then
    /usr/sbin/load_policy
    %relabel_files

fi;
exit 0

%postun
if [ $1 -eq 0 ]; then
    semodule -n -r container_process2
    if /usr/sbin/selinuxenabled ; then
       /usr/sbin/load_policy
       %relabel_files

    fi;
fi;
exit 0

%files
%attr(0600,root,root) %{_datadir}/selinux/packages/container_process2.pp
%{_datadir}/selinux/devel/include/contrib/container_process2.if
%{_mandir}/man8/container_process2_selinux.8.*


%changelog
* Fri Oct 16 2015 Jeroen Rijken <Jeroen.Rijken@nl.thalesgroup.com> 1.1-2
- Fix allow file rule
* Fri Oct 16 2015 Jeroen Rijken <Jeroen.Rijken@nl.thalesgroup.com> 1.1-1
- Create tunable policy for reading etc files
* Thu Oct 15 2015 Jeroen Rijken <Jeroen.Rijken@nl.thalesgroup.com> 1.0-1
- Final release

