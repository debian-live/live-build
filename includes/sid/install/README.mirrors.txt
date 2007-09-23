                 Debian worldwide mirror sites
                        -----------------------------

Debian is distributed (mirrored) on hundreds of
servers on the Internet. Using a nearby server will probably speed up your
download, and also reduce the load on our central servers and on the
Internet as a whole.

Debian mirrors can be primary and secondary. The definitions are as follows:

  A primary mirror site has good bandwidth, is available 24 hours a day,
  and has an easy to remember name of the form ftp.<country>.debian.org.
  Additionally, most of them are updated automatically after updates to the
  Debian archive. The Debian archive on those sites is normally available
  using both FTP and HTTP protocols.

  A secondary mirror site may have restrictions on what they mirror (due to
  space restrictions). Just because a site is secondary doesn't necessarily
  mean it'll be any slower or less up to date than a primary site.

Use the site closest to you for the fastest downloads possible whether it is
a primary or secondary site. The program `netselect' can be used to
determine the site with the least latency; use a download program such as
`wget' or `rsync' for determining the site with the most throughput.
Note that geographic proximity often isn't the most important factor for
determining which machine will serve you best.

The authoritative copy of the following list can always be found at:
                      http://www.debian.org/mirror/list
If you know of any mirrors that are missing from this list,
please have the site maintainer fill out the form at:
                     http://www.debian.org/mirror/submit
Everything else you want to know about Debian mirrors:
                        http://www.debian.org/mirror/


                         Primary Debian mirror sites
                         ---------------------------

 Country         Site                  Debian archive  Architectures
 ---------------------------------------------------------------------------
 Austria         ftp.at.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Australia       ftp.au.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Australia       ftp.wa.au.debian.org  /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Bulgaria        ftp.bg.debian.org     /debian/        alpha amd64 arm i386 ia64 m68k mips mipsel powerpc sparc
 Brazil          ftp.br.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Switzerland     ftp.ch.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Chile           ftp.cl.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Czech Republic  ftp.cz.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Germany         ftp.de.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Germany         ftp2.de.debian.org    /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Denmark         ftp.dk.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Estonia         ftp.ee.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Spain           ftp.es.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Finland         ftp.fi.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 France          ftp.fr.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 France          ftp2.fr.debian.org    /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Great Britain   ftp.uk.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Hong Kong       ftp.hk.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Croatia         ftp.hr.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Hungary         ftp.hu.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Ireland         ftp.ie.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Iceland         ftp.is.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Italy           ftp.it.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Japan           ftp.jp.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Japan           ftp2.jp.debian.org    /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Korea           ftp.kr.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Mexico          ftp.mx.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Netherlands     ftp.nl.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Norway          ftp.no.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 powerpc s390 sparc
 New Zealand     ftp.nz.debian.org     /debian/        alpha amd64 arm hurd-i386 i386 ia64 m68k mips mipsel powerpc sparc
 Poland          ftp.pl.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Romania         ftp.ro.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Russia          ftp.ru.debian.org     /debian/        amd64 i386
 Sweden          ftp.se.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Slovenia        ftp.si.debian.org     /debian/        alpha amd64 i386 ia64 m68k powerpc sparc
 Slovakia        ftp.sk.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Turkey          ftp.tr.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Taiwan          ftp.tw.debian.org     /debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 United States   ftp.us.debian.org     /debian/        amd64 i386


                   Secondary mirrors of the Debian archive
                   ---------------------------------------

HOST NAME                         FTP                                     HTTP                                ARCHITECTURES
---------                         ---                                     ----                                -------------

AR Argentina
------------
debian.logiclinux.com                                                    /debian/                           i386
ftp.ccc.uba.ar                    /pub/linux/debian/debian/              /pub/linux/debian/debian/          amd64 i386

AT Austria
----------
ftp.at.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
gd.tuwien.ac.at                   /opsys/linux/debian/                   /opsys/linux/debian/               alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.mur.at                     /debian/                               /debian/                           amd64 i386 ia64
ftp.tu-graz.ac.at                 /mirror/debian/                        /mirror/debian/                    alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.univie.ac.at                  /systems/linux/debian/debian/          /systems/linux/debian/debian/      i386
debian.inode.at                   /debian/                               /debian/                           alpha amd64 arm i386 powerpc sparc

AU Australia
------------
ftp.wa.au.debian.org              /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.au.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.aarnet.edu.au              /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.monash.edu.au                 /pub/linux/debian/                     /pub/linux/debian/                 amd64 i386
ftp.uwa.edu.au                    /debian/                               /debian/                           amd64 i386
mirror.eftel.com                  /debian/                               /debian/                           amd64 i386
mirror.pacific.net.au             /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.iinet.net.au                  /debian/debian/                        /debian/debian/                    alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.datafast.net.au            /debian/                               /debian/                           amd64 i386
mirror.optus.net                  /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

BE Belgium
----------
ftp.kulnet.kuleuven.ac.be         /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.easynet.be                    /debian/                               /ftp/debian/                       alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.belnet.be                     /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.debian.skynet.be              /debian/                               /ftp/debian/                       alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.scarlet.be                    /pub/debian/                           /pub/debian/                       alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

BG Bulgaria
-----------
ftp.bg.debian.org                 /debian/                               /debian/                           alpha amd64 arm i386 ia64 m68k mips mipsel powerpc sparc
debian.ludost.net                 /debian/                               /debian/                           i386
ftp.uni-sofia.bg                  /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.telecoms.bg                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

BR Brazil
---------
ftp.br.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
sft.if.usp.br                                                            /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
linorg.usp.br                     /debian/                               /debian/                           i386
linux.iq.usp.br                                                          /debian/                           amd64 i386
ftp.pucpr.br                      /debian/                                                                  amd64 hurd-i386 i386
www.las.ic.unicamp.br             /pub/debian/                           /pub/debian/                       amd64 hurd-i386 i386 powerpc sparc
debian.pop-sc.rnp.br                                                     /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

BY Belarus
----------
linux.org.by                      /debian/                               /debian/                           amd64 i386
ftp.mgts.by                       /debian/                               /debian/                           amd64 i386

CA Canada
---------
debian.yorku.ca                                                          /debian/                           amd64 i386
ftp3.nrc.ca                       /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
gulus.usherbrooke.ca              /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.cpsc.ucalgary.ca           /debian/                               /debian/                           amd64 i386
mirror.peer1.net                                                         /debian/                           alpha amd64 arm i386 mips mipsel powerpc sparc
debian.mirror.rafal.ca            /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.savoirfairelinux.net       /debian/                               /debian/                           amd64 i386 powerpc
debian.mirror.iweb.ca             /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

CH Switzerland
--------------
ftp.ch.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.switch.ch                  /mirror/debian/                        /ftp/mirror/debian/                alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

CL Chile
--------
ftp.cl.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.ubiobio.cl                                                        /debian/                           amd64 i386 powerpc sparc

CN China
--------
ftp.linuxforum.net                /debian/                                                                  i386
mirrors.geekbone.org              /debian/                               /debian/                           alpha amd64 hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.cn99.com                   /debian/                               /debian/                           amd64 i386

CZ Czech Republic
-----------------
ftp.cz.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.sh.cvut.cz                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.zcu.cz                        /mirrors/debian/                       /mirrors/debian/                   amd64 i386
debian.mirror.web4u.cz            /                                      /                                  amd64 i386

DE Germany
----------
ftp.de.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp2.de.debian.org                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.tu-clausthal.de               /pub/linux/debian/                                                        amd64 arm i386 ia64 m68k mips powerpc sparc
debian.uni-essen.de               /debian/                               /debian/                           amd64 hurd-i386 i386 ia64 m68k mips mipsel powerpc sparc
ftp.freenet.de                    /pub/ftp.debian.org/debian/            /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
sunsite.informatik.rwth-aachen.de /pub/Linux/debian/                     /ftp/pub/Linux/debian/             alpha amd64 i386 powerpc sparc
ftp-stud.fht-esslingen.de         /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.stw-bonn.de                   /debian/                               /debian/                           amd64 i386
ftp.fu-berlin.de                  /pub/unix/linux/mirrors/debian/                                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.tu-bs.de                   /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.uni-koeln.de                  /debian/                               /debian/                           alpha amd64 i386 powerpc sparc
debian.pffa.de                    /pub/mirrors/debian/                   /mirrors/debian/                   i386
ftp.mpi-sb.mpg.de                 /pub/linux/distributions/debian/debian/                                   alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.tiscali.de                    /pub/debian/debian/                    /pub/debian/debian/                amd64 arm hurd-i386 i386 ia64
ftp.tu-chemnitz.de                /pub/linux/debian/debian/              /pub/linux/debian/debian/          alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.uni-kl.de                     /debian/                               /debian/                           amd64 i386 ia64 powerpc sparc
ftp.uni-bayreuth.de               /pub/linux/Debian/debian/              /linux/Debian/debian/              alpha amd64 hurd-i386 i386 ia64
ftp.informatik.hu-berlin.de       /pub/Mirrors/ftp.de.debian.org/debian/                                    alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.gwdg.de                       /pub/linux/debian/debian/              /pub/linux/debian/debian/          amd64 hurd-i386 i386
ftp.hosteurope.de                 /pub/linux/debian/                     /pub/linux/debian/                 alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.netcologne.de              /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
artfiles.org                      /debian/                               /debian/                           amd64 i386
debian.intergenia.de                                                     /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.swordcoast.net             /debian/                               /debian/                           alpha amd64 arm hurd-i386 i386 ia64 m68k powerpc
debian.cruisix.net                /debian/                               /debian/                           amd64 i386 powerpc
ftp.rrzn.uni-hannover.de          /debian/debian/                                                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian-ftp.charite.de                                                    /debian/                           i386

DK Denmark
----------
ftp.dk.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.dkuug.dk                      /pub/debian/                           /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.here.dk                                                           /debian/                           amd64 i386 ia64 mips powerpc
debian.uni-c.dk                                                          /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirrors.telianet.dk               /debian/                               /debian/                           amd64 i386 powerpc sparc

EE Estonia
----------
ftp.ee.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

ES Spain
--------
ftp.es.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.rediris.es                    /debian/                               /debian/                           alpha amd64 i386 ia64 powerpc sparc
ftp.cica.es                       /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.caliu.info                    /debian/                               /debian/                           i386 ia64 m68k mips mipsel powerpc sparc
ftp.gva.es                        /pub/mirror/debian/                    /mirror/debian/                    alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.gul.uc3m.es                   /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.um.es                         /mirror/debian/                                                           all
jane.uab.cat                      /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

FI Finland
----------
ftp.fi.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.funet.fi                      /pub/linux/mirrors/debian/             /pub/linux/mirrors/debian/         alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.jyu.fi                        /debian/                               /debian/                           alpha amd64 hurd-i386 i386 powerpc sparc

FR France
---------
ftp.fr.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp2.fr.debian.org                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.iut-bm.univ-fcomte.fr         /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.proxad.net                    /mirrors/ftp.debian.org/                                                  alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.lip6.fr                       /pub/linux/distributions/debian/       /pub/linux/distributions/debian/   amd64 i386
debian.ens-cachan.fr              /debian/                               /ftp/debian/                       alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.u-picardie.fr                 /mirror/debian/                        /mirror/debian/                    alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.mirrors.easynet.fr         /debian/                               /                                  alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.u-strasbg.fr                  /debian/                               /debian/                           alpha amd64 hurd-i386 i386 ia64 m68k powerpc sparc
debian.ibisc.univ-evry.fr         /debian/                               /debian/                           amd64 i386
mir1.ovh.net                      /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mir2.ovh.net                                                             /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.nerim.net                     /debian/                               /debian/                           i386
ftp.crihan.fr                     /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.mines.inpl-nancy.fr        /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.debian.ikoula.com             /debian/                                                                  alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
webb.ens-cachan.fr                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirrors.ircam.fr                  /pub/debian/                           /pub/debian/                       alpha amd64 hurd-i386 i386 ia64 m68k mips mipsel powerpc sparc
debian.mirror.inra.fr             /debian/                               /debian/                           amd64 arm i386 ia64 powerpc sparc

GB Great Britain
----------------
ftp.uk.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.mcc.ac.uk                     /pub/linux/distributions/Debian/                                          hurd-i386 i386 sh
www.mirrorservice.org             /sites/ftp.debian.org/debian/          /sites/ftp.debian.org/debian/      amd64 i386
download.mirror.ac.uk             /sites/ftp.debian.org/debian/          /sites/ftp.debian.org/debian/      alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.ticklers.org                  /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.blueyonder.co.uk           /pub/debian/                           /                                  alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.positive-internet.com      /debian/                               /debian/                           amd64 hppa i386 ia64 powerpc
the.earth.li                      /debian/                               /debian/                           amd64 hurd-i386 i386
mirror.ox.ac.uk                   /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

GR Greece
---------
debian.otenet.gr                  /pub/linux/debian/                     /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.ntua.gr                       /pub/linux/debian/                     /pub/linux/debian/                 amd64 i386 sparc
ftp.duth.gr                       /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.softnet.tuc.gr                /pub/linux/debian/                     /ftp/linux/debian/                 alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.internet.gr                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

HK Hong Kong
------------
ftp.hk.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
www.zentek-international.com                                             /mirrors/debian/                   alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

HR Croatia
----------
ftp.hr.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.irb.hr                        /debian/                               /debian/                           amd64 arm hurd-i386 i386 ia64 powerpc sparc
ftp.carnet.hr                     /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.iskon.hr                   /debian/                               /debian/                           amd64 hurd-i386 i386 ia64 s390

HU Hungary
----------
ftp.hu.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.bme.hu                        /OS/Linux/dist/debian/                 /OS/Linux/dist/debian/             amd64 hurd-i386 i386 ia64

ID Indonesia
------------
kebo.vlsm.org                     /debian/                               /debian/                           amd64 hurd-i386 i386 powerpc
debian.indika.net.id                                                     /debian/                           i386

IE Ireland
----------
ftp.ie.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.esat.net                      /pub/linux/debian/                     /pub/linux/debian/                 alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

IL Israel
---------
mirror.hamakor.org.il                                                    /pub/mirrors/debian/               amd64 i386
debian.co.il                                                             /debian/                           amd64 i386

IS Iceland
----------
ftp.is.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

IT Italy
--------
ftp.it.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.bononia.it                    /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
freedom.dicea.unifi.it            /pub/linux/debian/                     /ftp/pub/linux/debian/             amd64 hurd-i386 i386
ftp.eutelia.it                    /pub/Debian_Mirror/                                                       alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mi.mirror.garr.it                 /mirrors/debian/                       /mirrors/debian/                   alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.fastweb.it                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.unina.it                      /pub/linux/distributions/debian/       /pub/linux/distributions/debian/   alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.fastbull.org               /debian/                               /debian/                           amd64 i386 powerpc sparc

JP Japan
--------
ftp.jp.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp2.jp.debian.org                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ring.asahi-net.or.jp              /pub/linux/debian/debian/              /archives/linux/debian/debian/     alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.dti.ad.jp                     /pub/Linux/debian/                     /pub/Linux/debian/                 alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
dennou-k.gfd-dennou.org           /library/Linux/debian/                 /library/Linux/debian/             alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
dennou-q.gfd-dennou.org           /library/Linux/debian/                 /library/Linux/debian/             alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.yz.yamagata-u.ac.jp           /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
sb.itc.u-tokyo.ac.jp              /DEBIAN/                               /DEBIAN/                           amd64 hurd-i386 i386 powerpc
ftp.riken.jp                      /pub/Linux/debian/debian/              /pub/Linux/debian/debian/          amd64 i386
debian.shimpinomori.net                                                  /debian/                           amd64 i386 powerpc
www.ring.gr.jp                    /pub/linux/debian/debian/              /archives/linux/debian/debian/     alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.jaist.ac.jp                   /pub/Linux/Debian/                     /pub/Linux/Debian/                 alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

KR Korea
--------
ftp.kr.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

LT Lithuania
------------
ameba.sc-uni.ktu.lt               /debian/                               /debian/                           i386
debian.balt.net                   /debian/                               /debian/                           amd64 arm i386 sparc

MX Mexico
---------
ftp.mx.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mmc.igeofcu.unam.mx                                                      /debian/                           amd64 hurd-i386 i386 ia64

NI Nicaragua
------------
debian.uni.edu.ni                                                        /debian/                           amd64 hurd-i386 i386

NL Netherlands
--------------
ftp.nl.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.nluug.nl                      /pub/os/Linux/distr/debian/            /pub/os/Linux/distr/debian/        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.surfnet.nl                    /pub/os/Linux/distr/debian/            /os/Linux/distr/debian/            alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.debian.nl                     /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.tiscali.nl                    /pub/mirrors/debian/                   /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.essentkabel.com            /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.scarlet-internet.nl        /pub/debian/                           /pub/debian/                       alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

NO Norway
---------
ftp.no.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 powerpc s390 sparc

NZ New Zealand
--------------
ftp.nz.debian.org                 /debian/                               /debian/                           alpha amd64 arm hurd-i386 i386 ia64 m68k mips mipsel powerpc sparc
debian.ihug.co.nz                 /debian/                               /debian/                           amd64 i386

PL Poland
---------
ftp.pl.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.icm.edu.pl                    /pub/Linux/debian/                     /pub/Linux/debian/                 alpha amd64 hurd-i386 i386 sparc
ftp.man.szczecin.pl               /pub/Linux/debian/                                                        alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.vectranet.pl                  /debian/                               /debian/                           amd64 i386

PT Portugal
-----------
ftp.uevora.pt                     /debian/                               /debian/                           amd64 i386
ftp.eq.uc.pt                      /pub/software/Linux/debian/            /software/Linux/debian/            amd64 i386
debian.ua.pt                      /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.linux.pt                      /pub/mirrors/debian/                   /pub/mirrors/debian/               amd64 hurd-i386 i386
ftp.telepac.pt                    /pub/debian/                                                              all

RO Romania
----------
ftp.ro.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.lug.ro                        /debian/                               /debian/                           amd64 i386 powerpc

RU Russia
---------
ftp.ru.debian.org                 /debian/                               /debian/                           amd64 i386
debian.nsu.ru                     /debian/                               /debian/                           amd64 i386
debian.udsu.ru                    /debian/                               /debian/                           amd64 i386
ftp.psn.ru                        /debian/                               /debian/                           alpha amd64 hurd-i386 i386
ftp.corbina.ru                    /pub/Linux/debian/                                                        amd64 i386 ia64
ftp.mipt.ru                       /debian/                                                                  alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

SE Sweden
---------
ftp.se.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.sunet.se                      /pub/os/Linux/distributions/debian/    /pub/os/Linux/distributions/debian/alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.port80.se                     /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.ds.hj.se                      /pub/os/linux/debian/                  /pub/os/linux/debian/              alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.bsnet.se                   /debian/                                                                  i386

SG Singapore
------------
mirror.nus.edu.sg                 /pub/Debian/                           /Debian/                           amd64 i386
debian.wow-vision.com.sg          /debian/                               /debian/                           amd64 i386

SI Slovenia
-----------
ftp.si.debian.org                 /debian/                               /debian/                           alpha amd64 i386 ia64 m68k powerpc sparc
ftp.arnes.si                      /packages/debian/                                                         amd64 hurd-i386 i386

SK Slovakia
-----------
ftp.sk.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

TH Thailand
-----------
ftp.coe.psu.ac.th                 /debian/                               /debian/                           i386
ftp.thaios.net                                                           /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

TR Turkey
---------
ftp.tr.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
godel.cs.bilgi.edu.tr                                                    /debian/                           hurd-i386 i386

TW Taiwan
---------
ftp.tw.debian.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.csie.ntu.edu.tw            /pub/debian/                           /debian/                           amd64 hurd-i386 i386
linux.cdpa.nsysu.edu.tw                                                  /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
opensource.nchc.org.tw            /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.nctu.edu.tw                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.nttu.edu.tw                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.csie.nctu.edu.tw           /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

UA Ukraine
----------
debian.osdn.org.ua                /pub/Debian/debian/                    /debian/                           i386
debian.org.ua                     /debian/                               /debian/                           i386
ftp.3logic.net                    /debian/                                                                  i386

US United States
----------------
ftp.us.debian.org                 /debian/                               /debian/                           amd64 i386
ftp.debian.org                    /debian/                               /debian/                           amd64 i386
ftp.gtlib.gatech.edu              /pub/debian/                           /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.egr.msu.edu                   /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
distro.ibiblio.org                /pub/linux/distributions/debian/       /pub/linux/distributions/debian/   amd64 hurd-i386 i386 powerpc
ftp-mirror.internap.com           /pub/debian/                           /pub/debian/                       alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.cerias.purdue.edu             /pub/os/debian/                        /pub/os/debian/                    amd64 i386
ftp.cs.unm.edu                    /mirrors/debian/                                                          alpha arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.cs.wisc.edu                /pub/mirrors/linux/debian/             /pub/mirrors/linux/debian/         amd64 i386
ftp.uwsg.indiana.edu              /linux/debian/                         /linux/debian/                     alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
natasha.stmarytx.edu              /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.ndlug.nd.edu                  /debian/                               /mirrors/debian/                   alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.uchicago.edu               /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
carroll.aset.psu.edu              /pub/linux/distributions/debian/       /pub/linux/distributions/debian/   alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.fifi.org                   /pub/debian/                           /debian/                           amd64 i386 sparc
gladiator.real-time.com           /linux/debian/                                                            alpha amd64 i386 powerpc sparc
mirrors.kernel.org                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.keystealth.org                /debian/                               /debian/                           amd64 hurd-i386 i386 ia64 mips mipsel sparc
debian.lcs.mit.edu                /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
linux.csua.berkeley.edu           /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.secsup.org                 /pub/linux/debian/                     /                                  alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
techweb.rfa.org                   /debian/                               /debian/                           amd64 i386
debian.osuosl.org                 /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.anl.gov                    /pub/debian/                           /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
sluglug.ucsc.edu                                                         /debian/                           amd64 hurd-i386 i386 powerpc sparc
mirrors.geeks.org                 /debian/                               /debian/                           amd64 i386
debian.midco.net                                                         /debian/                           i386
mirrors.usc.edu                   /pub/linux/distributions/debian/       /pub/linux/distributions/debian/   alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.mirrors.pair.com           /                                      /                                  alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
lug.mtu.edu                       /debian/                               /debian/                           alpha amd64 hppa i386 mips mipsel powerpc sparc
debian.mirrors.tds.net            /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.cites.uiuc.edu             /pub/debian/                           /pub/debian/                       amd64 hurd-i386 i386 ia64 powerpc sparc
mirrors.tummy.com                 /pub/ftp.debian.org/                   /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.mirror.frontiernet.net     /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
cudlug.cudenver.edu               /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
mirror.tucdemonic.org                                                    /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
bigmirror.crossbowproject.net     /pub/debian/                                                              alpha arm hppa i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.cise.ufl.edu                  /pub/mirrors/debian/                                                      amd64 i386
mirror.cc.columbia.edu            /pub/linux/debian/debian/              /pub/linux/debian/debian/          amd64 i386 powerpc

VE Venezuela
------------
debian.unesr.edu.ve                                                      /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

ZA South Africa
---------------
ftp.sun.ac.za                     /debian/                               /ftp/debian/                       amd64 i386
debian.mirror.ac.za               /debian/                               /debian/                           alpha amd64 arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc

-------------------------------------------------------------------------------
Last modified: Thu Apr  5 07:52:11 2007             Number of sites listed: 301
