%undefine __brp_mangle_shebangs

Name: redborder-ai
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch: noarch
Summary: Main package for redborder AI

License: AGPL 3.0
URL: https://github.com/redBorder/redborder-ai
Source0: %{name}-%{version}.tar.gz

Requires: bash

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/etc/redborder
mkdir -p %{buildroot}/usr/lib/redborder/bin
mkdir -p %{buildroot}/usr/lib/redborder/scripts
mkdir -p %{buildroot}/etc/logrotate.d
cp resources/bin/* %{buildroot}/usr/lib/redborder/bin
cp resources/scripts/rb_get_ai_model.rb %{buildroot}/usr/lib/redborder/scripts/rb_get_ai_model.rb
cp resources/logrotate.d/redborder-ai %{buildroot}/etc/logrotate.d/redborder-ai
chmod 0755 %{buildroot}/usr/lib/redborder/bin/*
install -D -m 0644 resources/systemd/redborder-ai.service %{buildroot}/usr/lib/systemd/system/redborder-ai.service

%pre

%post
systemctl daemon-reload
mkdir -p /var/log/redborder-ai
[ -f /usr/lib/redborder/bin/rb_rubywrapper.sh ] && /usr/lib/redborder/bin/rb_rubywrapper.sh -c
if command -v firewall-cmd &> /dev/null; then
  firewall-cmd --zone=home --add-port=50505/tcp --permanent
fi

%files
%defattr(0755,root,root)
/usr/lib/redborder/bin
/usr/lib/redborder/scripts/rb_get_ai_model.rb
%defattr(0644,root,root)
/etc/redborder
/usr/lib/systemd/system/redborder-ai.service
/etc/logrotate.d/redborder-ai
%doc

%changelog
* Tue Nov 12 2024 Pablo Pérez <pperez@redborder.com> - 0.0.2-1
- open port on installation
* Tue Jul 23 2024 Pablo Pérez <pperez@redborder.com> - 0.0.1-1
- first spec version
