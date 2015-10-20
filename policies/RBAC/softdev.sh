#!/bin/sh -e

DIRNAME=`dirname $0`
cd $DIRNAME
USAGE="$0 [ --update ]"
if [ `id -u` != 0 ]; then
echo 'You must be root to run this script'
exit 1
fi

if [ $# -eq 1 ]; then
	if [ "$1" = "--update" ] ; then
		time=`ls -l --time-style="+%x %X" softdev.te | awk '{ printf "%s %s", $6, $7 }'`
		rules=`ausearch --start $time -m avc --raw -se softdev`
		if [ x"$rules" != "x" ] ; then
			echo "Found avc's to update policy with"
			echo -e "$rules" | audit2allow -R
			echo "Do you want these changes added to policy [y/n]?"
			read ANS
			if [ "$ANS" = "y" -o "$ANS" = "Y" ] ; then
				echo "Updating policy"
				echo -e "$rules" | audit2allow -R >> softdev.te
				# Fall though and rebuild policy
			else
				exit 0
			fi
		else
			echo "No new avcs found"
			exit 0
		fi
	else
		echo -e $USAGE
		exit 1
	fi
elif [ $# -ge 2 ] ; then
	echo -e $USAGE
	exit 1
fi

echo "Building and Loading Policy"
set -x
make -f /usr/share/selinux/devel/Makefile softdev.pp || exit
/usr/sbin/semodule -i softdev.pp

# Generate a man page off the installed module
sepolicy manpage -p . -d softdev_t
# Adding SELinux user softdev_u
/usr/sbin/semanage user -a -R "softdev_r" softdev_u
cat > softdev_u << _EOF
softdev_r:softdev_t:s0	softdev_r:softdev_t
system_r:crond_t		softdev_r:softdev_t
system_r:initrc_su_t		softdev_r:softdev_t
system_r:local_login_t		softdev_r:softdev_t
system_r:remote_login_t		softdev_r:softdev_t
system_r:sshd_t			softdev_r:softdev_t
_EOF
if [ ! -f /etc/selinux/targeted/contexts/users/softdev_u ]; then
   cp softdev_u /etc/selinux/targeted/contexts/users/
fi
# Fix the file permissions on /usr/src/devbuild
mkdir -p /usr/src/build
/sbin/restorecon -F -R -v /usr/src/build
# Generate a rpm package for the newly generated policy

pwd=$(pwd)
rpmbuild --define "_sourcedir ${pwd}" --define "_specdir ${pwd}" --define "_builddir ${pwd}" --define "_srcrpmdir ${pwd}" --define "_rpmdir ${pwd}" --define "_buildrootdir ${pwd}/.build"  -ba softdev_selinux.spec
