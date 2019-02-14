### Notes/scratchpad

> https://github.com/sourcegraph/sourcegraph.git

> https://www.terraform.io/docs/providers/aws/index.html

* awscli example:

> aws ec2 run-instances --image-id ami-032509850cf9ee54e --count 1 --instance-type t2.medium --key-name id_rsa --security-groups default --user-data file://cloud-init.txt

```
The site configuration JSON is not yet stored in the database, so you must manually back it up. This will no longer be necessary in Sourcegraph 3.0. 
```

* Sourcegraph 3.0 new as of Feb 8, 2019 according to announcement: https://about.sourcegraph.com/blog/sourcegraph-3.0

* rds terraform example:

> https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/rds

* ec2 terraform example:

> https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/tree/master/examples/basic

```
https://github.com/terraform-aws-modules/terraform-aws-vpc
https://github.com/terraform-aws-modules/terraform-aws-ebs-optimized
https://github.com/terraform-aws-modules/terraform-aws-vpn-gateway
https://github.com/terraform-aws-modules/terraform-aws-rds
```

> DOCKER_OPTS="-g /data"

```
sourcegraph_config=/data/sourcegraph/config
sourcegraph_data=/data/sourcegraph/data
mkdir -p $sourcegraph_config
mkdir -p $sourcegraph_data
docker run \
	--publish 7080:7080 \
	--publish 2633:2633 \
	--rm --volume ${sourcegraph_config}:/etc/sourcegraph \
	--volume ${sourcegraph_data}:/var/opt/sourcegraph \
	sourcegraph/server:3.0.1
```

```
#cloud-config
  repo_update: true
  repo_upgrade: all

  runcmd:
  # Create the directory structure for Sourcegraph data
  - mkdir -p /home/ec2-user/.sourcegraph/config
  - mkdir -p /home/ec2-user/.sourcegraph/data
  
  # Install, configure, and enable Docker
  - yum update -y
  - amazon-linux-extras install docker
  - systemctl enable --now --no-block docker 
  - sed -i -e 's/1024/10240/g' /etc/sysconfig/docker
  - sed -i -e 's/4096/40960/g' /etc/sysconfig/docker
  - usermod -a -G docker ec2-user

  # Install and run Sourcegraph. Restart the container upon subsequent reboots
  - [ sh, -c, 'docker run -d --publish 80:7080 --publish 443:7443 --publish 2633:2633 --restart unless-stopped --volume /home/ec2-user/.sourcegraph/config:/etc/sourcegraph --volume /home/ec2-user/.sourcegraph/data:/var/opt/sourcegraph sourcegraph/server:3.0.1' ]
```

> https://docs.sourcegraph.com/admin/install/docker/aws

> Select an appropriate instance size (we recommend t2.medium/large, depending on team size and number of repositories/languages enabled), then Next: Configure Instance Details

* remote postgres/redis:

```
docker run [...] \
	-e PGHOST=psql.mycompany.org \
	-e PGUSER=sourcegraph \
	-e PGPASSWORD=secret \
	-e PGDATABASE=sourcegraph \
	-e PGSSLMODE=disable \
	-e REDIS_ENDPOINT=redis.mycompany.org:6379 \
	sourcegraph/server:3.0.1
```

> aws_elasticache_cluster.redis.configuration_endpoint

> aws_elasticache_cluster.redis.cluster_address

* lol nope, open issue for aws_elasticache_cluster.redis.cluster_address: https://github.com/terraform-providers/terraform-provider-aws/issues/3386

> aws_elasticache_cluster.redis.cache_nodes.0.address}:${aws_elasticache_cluster.redis.port

* aws_rds_cluster_instance error: https://github.com/terraform-providers/terraform-provider-aws/issues/2419

* github developer api: https://developer.github.com/v3/repos/

```
for i in {1..5}; do
curl -s  --header 'Accept: application/json' "https://api.github.com/users/enthought/repos?per_page=100&page=$i" | jq '.[] | . | select(.private==false) | .full_name'
done
```

* Full list of enthought public repos:

```
"enthought/appinst",
"enthought/apptools",
"enthought/atom",
"enthought/blockcanvas",
"enthought/bzip2",
"enthought/bzip2-1.0.6",
"enthought/casuarius",
"enthought/chaco",
"enthought/cla-gui",
"enthought/codetools",
"enthought/comtypes",
"enthought/ctraits",
"enthought/cve-search",
"enthought/cvxopt",
"enthought/cwrap",
"enthought/davidc-scipy-2013",
"enthought/db",
"enthought/db-4.7.25",
"enthought/depsolver",
"enthought/distarray",
"enthought/distributed-array-protocol",
"enthought/django-export",
"enthought/django-object-tools",
"enthought/edm-containers",
"enthought/edx-platform",
"enthought/edx-theme",
"enthought/edx_ansible",
"enthought/elfrewriter",
"enthought/enable",
"enthought/enable-mapping",
"enthought/enaml",
"enthought/encore",
"enthought/ensemble",
"enthought/enstaller",
"enthought/enstaller4rc",
"enthought/enthought-rpms",
"enthought/enthought-sphinx-theme",
"enthought/envisage",
"enthought/EPD_8",
"enthought/erinyes",
"enthought/ets",
"enthought/ets-examples",
"enthought/etsdevtools",
"enthought/etsproxy",
"enthought/euroscipy_2013_chaco_tutorial",
"enthought/fabric-winrm-fork",
"enthought/flask-apiblueprint",
"enthought/glfwpy",
"enthought/gom-jabbar",
"enthought/graph",
"enthought/graphcanvas",
"enthought/GraphicsBench",
"enthought/graystruct",
"enthought/grunt-escaped-seo",
"enthought/hmmlearn",
"enthought/ibm2ieee",
"enthought/ipython",
"enthought/ipython-website",
"enthought/jigna",
"enthought/machotools",
"enthought/mayavi",
"enthought/Meta",
"enthought/mkl_fft",
"enthought/ncurses-5.5",
"enthought/NECOFS",
"enthought/nfftpy",
"enthought/numpy-refactor",
"enthought/Numpy-Tutorial-SciPyConf-2015",
"enthought/Numpy-Tutorial-SciPyConf-2016",
"enthought/Numpy-Tutorial-SciPyConf-2017",
"enthought/Numpy-Tutorial-SciPyConf-2018",
"enthought/okonomiyaki",
"enthought/openssl",
"enthought/packer-templates-1",
"enthought/pikos",
"enthought/Project-Rescue",
"enthought/public-data",
"enthought/pydata-ldn-2014",
"enthought/pyface",
"enthought/pyflakes",
"enthought/pygotham",
"enthought/pyinstaller",
"enthought/pyql",
"enthought/pyside",
"enthought/PySide-BuildScripts",
"enthought/PySide-old",
"enthought/pyside-setup",
"enthought/PySide-Tools",
"enthought/PyTables",
"enthought/pytest-relaxed",
"enthought/Python-2.7.3",
"enthought/python-analytics",
"enthought/python-pptx",
"enthought/python-replicated",
"enthought/python-TDS",
"enthought/pywin32-ctypes",
"enthought/pywinrm-fork",
"enthought/pyxll-utils",
"enthought/qt-mobility",
"enthought/qtconsole",
"enthought/qt_binder",
"enthought/quandl-python",
"enthought/readthedocs.org",
"enthought/rested",
"enthought/sailor",
"enthought/salt-bootstrap",
"enthought/sandia-data-archive",
"enthought/sat-solver",
"enthought/scimath",
"enthought/scipy-conference",
"enthought/scipy-refactor",
"enthought/sectiondoc",
"enthought/shiboken",
"enthought/Shiboken-old",
"enthought/sqlite",
"enthought/sqlite-3.7.3",
"enthought/supplement",
"enthought/tabs",
"enthought/tcl",
"enthought/terraform-modules",
"enthought/textacy",
"enthought/tk",
"enthought/trait-documenter",
"enthought/traits",
"enthought/traits-enaml",
"enthought/traits-futures",
"enthought/traits4",
"enthought/traitsbackendqt",
"enthought/traitsgui",
"enthought/traitsui",
"enthought/uchicago-pyanno",
"enthought/vendor-atlas",
"enthought/vendor-mingw",
"enthought/VTK",
"enthought/xenserver-kickstart"
```

* Monitoring of https://sourcegraph.hodly.group ---> https://uptimerobot.com
