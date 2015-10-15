# vim: sw=4:ts=4:et


%define relabel_files() \
restorecon -R /home/admin/mlsuser.sh; \

%define selinux_policyver 3.13.1-23

Name:   mlsuser_selinux
Version:	0.1
Release:	1%{?dist}
Summary:	SELinux policy module for mlsuser

Group:	System Environment/Base		
License:	GPLv2
# This is an example. You will need to change it.
URL:		https://github.com/Jeroen0494/SELinuxPolicies/tree/mlsuser
Source0:	mlsuser.pp
Source1:	mlsuser.if
Source2:	mlsuser_selinux.8


Requires: policycoreutils, libselinux-utils
Requires(post): selinux-policy-base >= %{selinux_policyver}, policycoreutils
Requires(postun): policycoreutils
BuildArch: noarch

%description
This package installs and sets up the  SELinux policy security module for mlsuser.

%install
install -d %{buildroot}%{_datadir}/selinux/packages
install -m 644 %{SOURCE0} %{buildroot}%{_datadir}/selinux/packages
install -d %{buildroot}%{_datadir}/selinux/devel/include/contrib
install -m 644 %{SOURCE1} %{buildroot}%{_datadir}/selinux/devel/include/contrib/
install -d %{buildroot}%{_mandir}/man8/
install -m 644 %{SOURCE2} %{buildroot}%{_mandir}/man8/mlsuser_selinux.8
install -d %{buildroot}/etc/selinux/targeted/contexts/users/


%post
semodule -n -i %{_datadir}/selinux/packages/mlsuser.pp
if /usr/sbin/selinuxenabled ; then
    /usr/sbin/load_policy
    %relabel_files

fi;
exit 0

%postun
if [ $1 -eq 0 ]; then
    semodule -n -r mlsuser
    if /usr/sbin/selinuxenabled ; then
       /usr/sbin/load_policy
       %relabel_files

    fi;
fi;
exit 0

%files
%attr(0600,root,root) %{_datadir}/selinux/packages/mlsuser.pp
%{_datadir}/selinux/devel/include/contrib/mlsuser.if
%{_mandir}/man8/mlsuser_selinux.8.*


%changelog
* Thu Oct 15 2015 Jeroen Rijken <Jeroen.Rijken@nl.thalesgroup.com> 0.1-1
- First non-working version

