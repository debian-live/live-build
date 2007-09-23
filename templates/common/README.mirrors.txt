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
 Austria         ftp.at.debian.org     /debian/        alpha arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
 Australia       ftp.au.debian.org     /debian/        all
 Australia       ftp.wa.au.debian.org  /debian/        all
 Bulgaria        ftp.bg.debian.org     /debian/        !hppa !hurd-i386 !s390
 Brazil          ftp.br.debian.org     /debian/        all
 Switzerland     ftp.ch.debian.org     /debian/        all
 Chile           ftp.cl.debian.org     /debian/        all
 Czech Republic  ftp.cz.debian.org     /debian/        all
 Germany         ftp.de.debian.org     /debian/        all
 Germany         ftp2.de.debian.org    /debian/        all
 Estonia         ftp.ee.debian.org     /debian/        all
 Spain           ftp.es.debian.org     /debian/        all
 Finland         ftp.fi.debian.org     /debian/        all
 France          ftp.fr.debian.org     /debian/        all
 France          ftp2.fr.debian.org    /debian/        all
 Great Britain   ftp.uk.debian.org     /debian/        all
 Hong Kong       ftp.hk.debian.org     /debian/        all
 Croatia         ftp.hr.debian.org     /debian/        all
 Hungary         ftp.hu.debian.org     /debian/        all
 Ireland         ftp.ie.debian.org     /debian/        all
 Iceland         ftp.is.debian.org     /debian/        all
 Italy           ftp.it.debian.org     /debian/        all
 Japan           ftp.jp.debian.org     /debian/        all
 Japan           ftp2.jp.debian.org    /debian/        all
 Korea           ftp.kr.debian.org     /debian/        all
 Netherlands     ftp.nl.debian.org     /debian/        all
 Norway          ftp.no.debian.org     /debian/        !m68k
 New Zealand     ftp.nz.debian.org     /debian/        all
 Poland          ftp.pl.debian.org     /debian/        all
 Romania         ftp.ro.debian.org     /debian/        all
 Russia          ftp.ru.debian.org     /debian/        all
 Sweden          ftp.se.debian.org     /debian/        all
 Slovenia        ftp.si.debian.org     /debian/        alpha i386 ia64 m68k sparc
 Slovakia        ftp.sk.debian.org     /debian/        all
 Turkey          ftp.tr.debian.org     /debian/        all
 United States   ftp.us.debian.org     /debian/        !m68k !s390


                   Secondary mirrors of the Debian archive
                   ---------------------------------------

HOST NAME                         FTP                                      HTTP                                ARCHITECTURES
---------                         ---                                      ----                                -------------

AR Argentina
------------
debian.logiclinux.com                                                     /debian/                           i386
ftp.ccc.uba.ar                    /pub/linux/debian/debian/               /download/pub/linux/debian/debian/ i386
debian.usla.org.ar                                                        /debian/                           i386

AT Austria
----------
ftp.at.debian.org                 /debian/                                /debian/                           alpha arm hppa hurd-i386 i386 ia64 m68k mips mipsel powerpc s390 sparc
gd.tuwien.ac.at                   /opsys/linux/debian/                    /opsys/linux/debian/               all
debian.mur.at                     /debian/                                /debian/                           i386 ia64
ftp.tu-graz.ac.at                 /mirror/debian/                         /mirror/debian/                    all
ftp.univie.ac.at                  /systems/linux/debian/debian/           /systems/linux/debian/debian/      hurd-i386 i386
debian.inode.at                   /debian/                                /debian/                           alpha arm i386 m68k sparc

AU Australia
------------
ftp.wa.au.debian.org              /debian/                                /debian/                           all
ftp.au.debian.org                 /debian/                                /debian/                           all
mirror.aarnet.edu.au              /debian/                                /debian/                           !alpha
ftp.monash.edu.au                 /pub/linux/debian/                      /pub/linux/debian/                 i386
ftp.uwa.edu.au                    /mirrors/linux/debian/                                                     all
mirror.eftel.com                  /debian/                                /debian/                           i386
mirror.pacific.net.au             /debian/                                /debian/                           all
ftp.iinet.net.au                  /debian/debian/                         /debian/debian/                    all
debian.goldweb.com.au                                                     /debian/                           hurd-i386 i386
mirror.datafast.net.au            /debian/                                /debian/                           i386
debian.ihug.com.au                /debian/                                /debian/                           i386
debian.vicnet.net.au              /debian/                                /debian/                           i386
mirror.optus.net                                                          /debian/                           all

BE Belgium
----------
ftp.tiscali.be                    /pub/debian/                            /pub/debian/                       all
ftp.kulnet.kuleuven.ac.be         /debian/                                /debian/                           all
ftp.easynet.be                    /debian/                                /ftp/debian/                       all
ftp.belnet.be                     /debian/                                /debian/                           all
ftp.debian.skynet.be              /debian/                                /ftp/debian/                       all
ftp.scarlet.be                    /pub/debian/                            /pub/debian/                       all

BG Bulgaria
-----------
ftp.bg.debian.org                 /debian/                                /debian/                           !hppa !hurd-i386 !s390
debian.ludost.net                 /debian/                                /debian/                           i386
ftp.uni-sofia.bg                  /debian/                                /debian/                           all
debian.telecoms.bg                /debian/                                /debian/                           all

BR Brazil
---------
ftp.br.debian.org                 /debian/                                /debian/                           all
sft.if.usp.br                                                             /debian/                           i386
linorg.usp.br                     /debian/                                /debian/                           i386
linux.iq.usp.br                                                           /debian/                           i386 m68k
ftp.pucpr.br                      /debian/                                /debian/                           hurd-i386 i386
www.las.ic.unicamp.br             /pub/debian/                            /pub/debian/                       i386

BY Belarus
----------
linux.org.by                      /debian/                                /debian/                           i386
ftp.mgts.by                       /debian/                                                                   i386

CA Canada
---------
mirror.direct.ca                  /pub/linux/debian/                      /linux/debian/                     i386 ia64 sparc
debian.yorku.ca                                                           /debian/                           alpha i386
ftp3.nrc.ca                       /debian/                                /debian/                           i386
gulus.usherbrooke.ca              /debian/                                /debian/                           all
mirror.cpsc.ucalgary.ca           /debian/                                /debian/                           i386
mirror.peer1.net                                                          /debian/                           !hppa !ia64 !s390
debian.savoirfairelinux.net       /debian/                                /debian/                           all
debian.mirror.cygnal.ca           /debian/                                /debian/                           all

CH Switzerland
--------------
ftp.ch.debian.org                 /debian/                                /debian/                           all
mirror.switch.ch                  /mirror/debian/                         /ftp/mirror/debian/                all

CL Chile
--------
ftp.cl.debian.org                 /debian/                                /debian/                           all
debian.experimentos.cl            /Debian/debian/                         /debian/                           i386
debian.ubiobio.cl                                                         /debian/                           i386 sparc

CN China
--------
ftp.linuxforum.net                /debian/                                                                   i386
mirrors.geekbone.org              /debian/                                /debian/                           all
debian.cn99.com                   /debian/                                /debian/                           i386
mirror.vmmatrix.net                                                       /debian/                           !alpha !hppa !m68k !mipsel !s390

CO Colombia
-----------
fatboy.umng.edu.co                                                        /debian/                           alpha hurd-i386 i386 ia64 sparc
debian.funlam.edu.co                                                      /debian/                           i386

CR Costa Rica
-------------
debian.efis.ucr.ac.cr                                                     /debian/                           all

CZ Czech Republic
-----------------
ftp.cz.debian.org                 /debian/                                /debian/                           all
debian.sh.cvut.cz                 /debian/                                /debian/                           all
ftp.zcu.cz                        /pub/linux/debian/                      /ftp/pub/linux/debian/             i386

DE Germany
----------
ftp.de.debian.org                 /debian/                                /debian/                           all
ftp2.de.debian.org                /debian/                                /debian/                           all
ftp.tu-clausthal.de               /pub/linux/debian/                                                         alpha arm i386 ia64 m68k mips mipsel powerpc sparc
debian.uni-essen.de               /debian/                                /debian/                           i386
ftp.freenet.de                    /pub/ftp.debian.org/debian/             /debian/                           all
ftp.uni-erlangen.de               /pub/Linux/debian/                      /pub/Linux/debian/                 all
sunsite.informatik.rwth-aachen.de /pub/Linux/debian/                      /ftp/pub/Linux/debian/             alpha i386 sparc
ftp-stud.fht-esslingen.de         /debian/                                /debian/                           all
ftp.stw-bonn.de                   /debian/                                /debian/                           i386
ftp.fu-berlin.de                  /pub/unix/linux/mirrors/debian/                                            all
debian.tu-bs.de                   /debian/                                /debian/                           all
ftp.uni-koeln.de                  /debian/                                /debian/                           alpha i386 sparc
debian.pffa.de                    /pub/mirrors/debian/                    /mirrors/debian/                   hurd-i386 i386
ftp.mpi-sb.mpg.de                 /pub/linux/distributions/debian/debian/                                    all
ftp.tiscali.de                    /pub/debian/debian/                     /pub/debian/debian/                all
ftp.tu-chemnitz.de                /pub/linux/debian/debian/               /pub/linux/debian/debian/          all
ftp.uni-kl.de                     /pub/linux/debian/                      /debian/                           i386 ia64 sparc
ftp.uni-bayreuth.de               /pub/linux/Debian/debian/               /linux/Debian/debian/              !arm
ftp.informatik.hu-berlin.de       /pub/Mirrors/ftp.de.debian.org/debian/                                     all
ftp.gwdg.de                       /pub/linux/debian/debian/               /pub/linux/debian/debian/          all
ftp.hosteurope.de                 /pub/linux/debian/                      /pub/linux/debian/                 alpha arm hppa i386 ia64 m68k mips mipsel powerpc s390 sparc
ftp.informatik.uni-frankfurt.de   /pub/linux/Mirror/ftp.debian.org/debian//debian/                           i386 ia64
debian.netcologne.de              /debian/                                /debian/                           all

DK Denmark
----------
mirrors.dotsrc.org                /debian/                                /debian/                           all
ftp.dkuug.dk                      /pub/debian/                            /debian/                           all
mirror.here.dk                                                            /debian/                           !mips !mipsel
debian.uni-c.dk                                                           /debian/                           all
mirrors.telianet.dk               /debian/                                /debian/                           hurd-i386 i386 sparc

EE Estonia
----------
ftp.ee.debian.org                 /debian/                                /debian/                           all

ES Spain
--------
ftp.es.debian.org                 /debian/                                /debian/                           all
toxo.com.uvigo.es                 /debian/                                /debian/                           all
ftp.rediris.es                    /debian/                                /debian/                           alpha i386 ia64 sparc
jane.uab.es                                                               /debian/                           hurd-i386 i386
ftp.caliu.info                    /debian/                                /debian/                           i386 ia64 m68k mips mipsel powerpc sparc
ftp.cica.es                       /debian/                                                                   all
ftp.dat.etsit.upm.es              /debian/                                /debian/                           i386
ftp.gva.es                        /pub/mirror/debian/                     /mirror/debian/                    alpha arm hppa i386 ia64 m68k mips mipsel powerpc s390 sparc

FI Finland
----------
ftp.fi.debian.org                 /debian/                                /debian/                           all
ftp.funet.fi                      /pub/linux/mirrors/debian/              /pub/linux/mirrors/debian/         all
ftp.jyu.fi                        /debian/                                /debian/                           !arm !m68k !mips !mipsel !s390

FR France
---------
ftp.fr.debian.org                 /debian/                                /debian/                           all
ftp2.fr.debian.org                /debian/                                /debian/                           all
ftp.iut-bm.univ-fcomte.fr         /debian/                                /debian/                           all
ftp.proxad.net                    /mirrors/ftp.debian.org/                                                   all
ftp.minet.net                     /debian/                                                                   all
ftp.info.iut-tlse3.fr             /debian/                                /debian/                           i386 m68k
ftp.lip6.fr                       /pub/linux/distributions/debian/        /pub/linux/distributions/debian/   all
debian.ens-cachan.fr              /debian/                                /ftp/debian/                       i386 sparc
ftp.u-picardie.fr                 /mirror/debian/                         /mirror/debian/                    alpha i386
debian.mirrors.easynet.fr         /debian/                                /                                  alpha i386 powerpc
ftp.u-strasbg.fr                  /debian/                                /debian/                           !arm !hppa !mips !mipsel !s390
ftp.ipv6.opentransit.net          /debian/                                /debian/                           !mipsel
debian.lami.univ-evry.fr          /debian/                                                                   i386 sparc
mir1.ovh.net                      /debian/                                /debian/                           all
mir2.ovh.net                                                              /debian/                           all
ftp.nerim.net                     /debian/                                /debian/                           i386
ftp.crihan.fr                     /debian/                                /debian/                           all
debian.mines.inpl-nancy.fr        /debian/                                /debian/                           !alpha !arm !m68k
ftp.debian.ikoula.com             /debian/                                                                   all
webb.ens-cachan.fr                /debian/                                /debian/                           alpha arm hppa i386 ia64 m68k mips mipsel powerpc s390 sparc
mirrors.ircam.fr                  /pub/debian/                            /pub/debian/                       !arm !hppa !s390

GB Great Britain
----------------
ftp.uk.debian.org                 /debian/                                /debian/                           all
debian.hands.com                  /debian/                                /debian/                           all
ftp.demon.co.uk                   /pub/mirrors/linux/debian/                                                 all
ftp.mcc.ac.uk                     /pub/linux/distributions/Debian/                                           hurd-i386 i386 sh
www.mirrorservice.org             /sites/ftp.debian.org/debian/           /sites/ftp.debian.org/debian/      i386
download.mirror.ac.uk             /sites/ftp.debian.org/debian/           /sites/ftp.debian.org/debian/      all
ftp.ticklers.org                  /debian/                                /debian/                           all
debian.blueyonder.co.uk           /pub/debian/                            /                                  all
mirror.positive-internet.com      /debian/                                /debian/                           i386
the.earth.li                      /debian/                                /debian/                           hurd-i386 i386
mirror.ox.ac.uk                   /debian/                                /debian/                           all

GR Greece
---------
debian.otenet.gr                  /pub/linux/debian/                      /debian/                           all
ftp.ntua.gr                       /pub/linux/debian/                      /pub/linux/debian/                 i386 sparc
ftp.duth.gr                       /debian/                                /debian/                           all
ftp.softnet.tuc.gr                /pub/linux/debian/                      /ftp/linux/debian/                 all
debian.spark.net.gr                                                       /debian/                           i386 sparc
debian.internet.gr                /debian/                                /debian/                           i386 ia64 s390 sparc

HK Hong Kong
------------
ftp.hk.debian.org                 /debian/                                /debian/                           all
sunsite.ust.hk                    /pub/debian/                                                               all
www.zentek-international.com                                              /mirrors/debian/debian/            all

HR Croatia
----------
ftp.hr.debian.org                 /debian/                                /debian/                           all
ftp.irb.hr                        /debian/                                /debian/                           arm hurd-i386 i386 ia64 sparc
ftp.carnet.hr                     /debian/                                /debian/                           all
debian.iskon.hr                   /debian/                                /debian/                           hurd-i386 i386 ia64 s390

HU Hungary
----------
ftp.hu.debian.org                 /debian/                                /debian/                           all
ftp.index.hu                      /debian/                                                                   i386
debian.inf.elte.hu                /debian/                                /debian/                           all
ftp.bme.hu                        /OS/Linux/dist/debian/                  /OS/Linux/dist/debian/             hurd-i386 i386 ia64

ID Indonesia
------------
kebo.vlsm.org                     /debian/                                /debian/                           i386
debian.3wsi.net                                                           /debian/                           i386
debian.indika.net.id                                                      /debian/                           all

IE Ireland
----------
ftp.ie.debian.org                 /debian/                                /debian/                           all
ftp.esat.net                      /pub/linux/debian/                      /pub/linux/debian/                 all

IL Israel
---------
mirror.hamakor.org.il                                                     /pub/mirrors/debian/               i386

IN India
--------
ftp.iitm.ac.in                    /debian/                                /debian/                           i386

IS Iceland
----------
ftp.is.debian.org                 /debian/                                /debian/                           all

IT Italy
--------
ftp.it.debian.org                 /debian/                                /debian/                           all
ftp.bononia.it                    /debian/                                /debian/                           all
freedom.dicea.unifi.it            /ftp/pub/linux/debian/                  /ftp/pub/linux/debian/             hurd-i386 i386
ftp.eutelia.it                    /pub/Debian_Mirror/                                                        all
cdn.mirror.garr.it                                                        /mirrors/debian/                   alpha arm hppa i386 ia64 sparc
mi.mirror.garr.it                 /mirrors/debian/                        /mirrors/debian/                   alpha arm hppa i386 ia64 sparc
debian.fastweb.it                 /debian/                                /debian/                           all
ftp.unina.it                      /pub/linux/distributions/debian/        /pub/linux/distributions/debian/   alpha arm hppa i386 ia64 m68k mips mipsel powerpc s390 sparc
debian.fastbull.org               /debian/                                /debian/                           all

JP Japan
--------
ftp2.jp.debian.org                /debian/                                /debian/                           all
ftp.jp.debian.org                 /debian/                                /debian/                           all
ring.asahi-net.or.jp              /pub/linux/debian/debian/               /archives/linux/debian/debian/     all
ftp.dti.ad.jp                     /pub/Linux/debian/                      /pub/Linux/debian/                 all
dennou-k.gfd-dennou.org           /library/Linux/debian/                  /library/Linux/debian/             all
dennou-q.gfd-dennou.org           /library/Linux/debian/                  /library/Linux/debian/             all
ftp.yz.yamagata-u.ac.jp           /debian/                                /debian/                           all
sb.itc.u-tokyo.ac.jp              /DEBIAN/debian/                                                            all
ftp.riken.go.jp                   /pub/Linux/debian/debian/               /pub/Linux/debian/debian/          i386
debian.shimpinomori.net                                                   /debian/                           i386
ring.hosei.ac.jp                  /pub/linux/debian/debian/               /archives/linux/debian/debian/     all
www.ring.gr.jp                    /pub/linux/debian/debian/               /archives/linux/debian/debian/     all
ftp.jaist.ac.jp                   /pub/Linux/Debian/                      /pub/Linux/Debian/                 alpha arm hppa i386 ia64 m68k mips mipsel powerpc s390 sparc

KR Korea
--------
ftp.kr.debian.org                 /debian/                                /debian/                           all
ftp.kreonet.re.kr                 /pub/Linux/debian/                      /pub/Linux/debian/                 all

LT Lithuania
------------
ameba.sc-uni.ktu.lt               /debian/                                /debian/                           i386
debian.balt.net                   /debian/                                /debian/                           arm i386 sparc
debian.vinita.lt                  /debian/                                /debian/                           i386

LV Latvia
---------
ftp.latnet.lv                     /linux/debian/                          /linux/debian/                     hurd-i386 i386

MX Mexico
---------
nisamox.fciencias.unam.mx         /debian/                                /debian/                           all

NI Nicaragua
------------
debian.uni.edu.ni                                                         /debian/                           hurd-i386 i386

NL Netherlands
--------------
ftp.nl.debian.org                 /debian/                                /debian/                           all
ftp.nluug.nl                      /pub/os/Linux/distr/debian/             /pub/os/Linux/distr/debian/        all
ftp.eu.uu.net                     /debian/                                /debian/                           all
ftp.surfnet.nl                    /pub/os/Linux/distr/debian/             /os/Linux/distr/debian/            all
download.xs4all.nl                /pub/mirror/debian/                                                        all
ftp.debian.nl                     /debian/                                /debian/                           i386
ftp.tiscali.nl                    /pub/mirrors/debian/                    /debian/                           all
debian.essentkabel.com            /debian/                                /debian/                           all

NO Norway
---------
ftp.no.debian.org                 /debian/                                /debian/                           !m68k
debian.marked.no                  /debian/                                /debian/                           all

NZ New Zealand
--------------
ftp.nz.debian.org                 /debian/                                /debian/                           all
debian.ihug.co.nz                 /debian/                                /debian/                           i386

PL Poland
---------
ftp.pl.debian.org                 /debian/                                /debian/                           all
ftp.icm.edu.pl                    /pub/Linux/debian/                      /pub/Linux/debian/                 !arm !m68k
mirror.ipartners.pl               /pub/debian/                                                               all
ftp.man.szczecin.pl               /pub/Linux/debian/                                                         all

PT Portugal
-----------
ftp.uevora.pt                     /debian/                                /debian/                           i386
ftp.eq.uc.pt                      /pub/software/Linux/debian/             /software/Linux/debian/            i386
debian.ua.pt                      /debian/                                /debian/                           all
ftp.linux.pt                      /pub/mirrors/debian/                    /pub/mirrors/debian/               hurd-i386 i386

RO Romania
----------
ftp.ro.debian.org                 /debian/                                /debian/                           all
ftp.lug.ro                        /debian/                                /debian/                           i386 ia64

RU Russia
---------
ftp.ru.debian.org                 /debian/                                /debian/                           all
debian.nsu.ru                     /debian/                                /debian/                           i386
debian.udsu.ru                    /debian/                                /debian/                           i386
ftp.psn.ru                        /debian/                                /debian/                           hurd-i386 i386
ftp.corbina.ru                    /pub/Linux/debian/                                                         i386 ia64

SE Sweden
---------
ftp.se.debian.org                 /debian/                                /debian/                           all
ftp.sunet.se                      /pub/os/Linux/distributions/debian/     /pub/os/Linux/distributions/debian/all
ftp.du.se                         /debian/                                /debian/                           all
kalle.csb.ki.se                   /pub/linux/debian/                      /pub/linux/debian/                 i386 sparc
mirror.pudas.net                  /debian/                                /debian/                           all
ftp.port80.se                     /debian/                                /debian/                           all
ftp.ds.hj.se                      /pub/Linux/distributions/debian/        /pub/Linux/distributions/debian/   i386 powerpc sparc

SG Singapore
------------
mirror.averse.net                 /debian/                                /debian/                           i386
mirror.nus.edu.sg                 /pub/Debian/                            /Debian/                           alpha hurd-i386 i386
debian.wow-vision.com.sg          /debian/                                /debian/                           i386

SI Slovenia
-----------
ftp.si.debian.org                 /debian/                                /debian/                           alpha i386 ia64 m68k sparc
ftp.arnes.si                      /packages/debian/                                                          all

SK Slovakia
-----------
ftp.sk.debian.org                 /debian/                                /debian/                           all

TH Thailand
-----------
ftp.nectec.or.th                  /pub/linux-distributions/Debian/                                           all
ftp.coe.psu.ac.th                 /debian/                                /debian/                           !arm !hppa !ia64 !sparc

TR Turkey
---------
ftp.tr.debian.org                 /debian/                                /debian/                           all
ftp.linux.org.tr                  /pub/mirrors/debian/                                                       all

TW Taiwan
---------
ftp.tku.edu.tw                    /OS/Linux/distributions/debian/         /OS/Linux/distributions/debian/    all
debian.csie.ntu.edu.tw            /pub/debian/                            /debian/                           hurd-i386 i386
debian.linux.org.tw               /debian/                                /debian/                           all
linux.cdpa.nsysu.edu.tw           /debian/                                /debian/                           all
opensource.nchc.org.tw            /debian/                                /debian/                           all
debian.nctu.edu.tw                                                        /debian/                           all

UA Ukraine
----------
debian.osdn.org.ua                /pub/Debian/debian/                     /debian/                           i386
debian.org.ua                     /debian/                                /debian/                           i386
ftp.3logic.net                    /debian/                                                                   i386

US United States
----------------
ftp.us.debian.org                 /debian/                                /debian/                           !m68k !s390
ftp.debian.org                    /debian/                                /debian/                           i386
debian.crosslink.net              /debian/                                /debian/                           all
ftp-linux.cc.gatech.edu           /debian/                                /debian/                           all
ftp.egr.msu.edu                   /debian/                                /debian/                           all
distro.ibiblio.org                /pub/linux/distributions/debian/        /pub/linux/distributions/debian/   hurd-i386 i386 sparc
ftp-mirror.internap.com           /pub/debian/                            /pub/debian/                       all
ftp.cerias.purdue.edu             /pub/os/debian/                         /pub/os/debian/                    i386
ftp.cs.unm.edu                    /mirrors/debian/                                                           all
mirror.cs.wisc.edu                /pub/mirrors/linux/debian/              /pub/mirrors/linux/debian/         i386
ftp.uwsg.indiana.edu              /linux/debian/                          /linux/debian/                     all
natasha.stmarytx.edu                                                      /debian/                           all
ftp.ndlug.nd.edu                  /debian/                                /mirrors/debian/                   all
debian.uchicago.edu               /debian/                                /debian/                           all
carroll.aset.psu.edu              /pub/linux/distributions/debian/        /pub/linux/distributions/debian/   all
debian.fifi.org                   /pub/debian/                            /debian/                           i386 sparc
gladiator.real-time.com           /linux/debian/                                                             i386
mirrors.kernel.org                /debian/                                /debian/                           all
mirrors.rcn.net                   /debian/                                /debian/                           i386
ftp.keystealth.org                /debian/                                /debian/                           !alpha !arm !hppa !m68k !s390
debian.lcs.mit.edu                /debian/                                /debian/                           all
archive.progeny.com               /debian/                                /debian/                           all
linux.csua.berkeley.edu           /debian/                                /debian/                           all
debian.secsup.org                 /pub/linux/debian/                      /                                  all
debian.teleglobe.net              /debian/                                /                                  all
techweb.rfa.org                   /debian/                                /debian/                           all
debian.osuosl.org                 /debian/                                /debian/                           all
lyre.mit.edu                                                              /debian/                           all
mirror.mcs.anl.gov                /pub/debian/                            /debian/                           all
debian.2z.net                                                             /debian/                           i386
sluglug.ucsc.edu                  /debian/                                /debian/                           all
cudlug.cudenver.edu               /debian/                                /debian/                           alpha hurd-i386 i386 ia64 sparc
mirrors.geeks.org                 /debian/                                /debian/                           i386
mirrors.engr.arizona.edu                                                  /debian/                           i386
mirrors.terrabox.com              /debian/                                /debian/                           all
debian.midco.net                                                          /debian/                           all
mirrors.usc.edu                   /pub/linux/distributions/debian/        /pub/linux/distributions/debian/   all
debian.mirrors.pair.com           /                                       /                                  all
lug.mtu.edu                       /debian/                                /debian/                           alpha hppa i386 mips mipsel powerpc sparc
debian.mirrors.tds.net            /debian/                                /debian/                           all
debian.cites.uiuc.edu             /pub/debian/                            /pub/debian/                       alpha arm hppa i386 ia64 m68k mips mipsel powerpc s390 sparc
mirrors.tummy.com                 /pub/ftp.debian.org/                    /debian/                           all
debian.mirror.frontiernet.net     /debian/                                /debian/                           all

VE Venezuela
------------
debian.unesr.edu.ve                                                       /debian/                           all

ZA South Africa
---------------
ftp.is.co.za                      /debian/                                /debian/                           i386
ftp.sun.ac.za                     /debian/                                /ftp/debian/                       i386

-------------------------------------------------------------------------------
Last modified: Wed May 17 18:52:18 2006             Number of sites listed: 330
