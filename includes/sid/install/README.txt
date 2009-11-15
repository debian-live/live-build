
                                            (HTML version in README.html)

        DEBIAN_NAME
                             DEBIAN_DATE   



   CONTENTS:

     * Intro
     * About This Disc
     * Installing
     * Last-Minute Notes
     * Using CDs/DVDs with apt
     * CD/DVD Manufacturers
     * More Information


                     Welcome to the exciting world of 
                             Debian GNU/Linux! 

Intro
=====

   This is one disc in a set containing the the Debian GNU/Linux
   distribution. Debian is a very extensive collection of software. But
   it is more. It is a complete Operating System (OS) for your computer.
   And it is free (as in "freedom").

   An operating system is the set of basic programs and utilities that
   make your computer run. At the core of an operating system is the
   kernel. The kernel is the most fundamental program on the computer,
   which does all the basic housekeeping and lets you start other
   programs. Debian is kernel independent. It currently uses the Linux
   kernel but work is in progress to provide Debian for other kernels,
   using the Hurd. Most of the basic operating system tools come from the
   GNU project; hence the name GNU/Linux.

   Debian is available for various kinds of computers ("architectures"),
   like "IBM-compatible" PCs (i386), Compaq's Alpha, Sun's Sparc,
   Motorola/IBM's PowerPC, and (Strong)ARM processors. Check the ports
   page (http://www.debian.org/ports) for more information.

   Read more at

     http://www.debian.org/intro/about


About This Disc
=============

   This disc is labeled

     DEBIAN_NAME
   DEBIAN_DATE

   which means that this disc is number 1 of a set of 1 discs. It
   contains programs ("binaries") for `DEBIAN_ARCHITECTURE' computers.

   The programs on the Binary discs are ordered by popularity. The
   Binary-1 disc contains the most popular programs and the installation
   tools; it is possible to install and run Debian with only the Binary-1
   disc. The other discs, up to Binary-1, contain mostly
   special-interest programs.

   The Release Notes for "etch" are available on the Debian web site.


Installing
==========

   Because Debian is a complete Operating System, the installation
   procedure may seem a bit unusual. You can install Debian GNU/Linux
   either alongside your current OS, or as the only OS on your computer.

   An Installation Guide for this disc is available from the Debian web
   site.

   Programs and other files that are needed for the installation can be
   found on this disc under

     DEBIAN_TOOLS

   For the impatient ones: you can start the installation program easily
   by booting off this disc. Note that not all (esp. older) systems
   support this.

   You can examine the

     /install

   directory; you might be able to start the installation system directly
   from there.


Last-Minute Notes
=================

     * This is an official release of the Debian system. Please report
       any bugs you find in the Debian Bug Tracking System; details at
       [1]bugs.debian.org.
     * If you're reporting bugs against this disc or the installation
       system, please also mention the version of this disc; this can be
       found in the file /.disk/info.



Using Apt
=============

   After installing or upgrading, Debian's packaging system can use CDs,
   DVDs, local collections, or networked servers (FTP, HTTP) to
   automatically install software from (.deb packages). This is done
   preferably with the `apt' and `aptitude' programs.

   You can install packages from the commandline using apt-get. For
   example, if you want to install the packages `commprog' and `maxgame',
   you can give the command

     apt-get install commprog maxgame

   Note that you don't have to enter the complete path, or the `.deb'
   extension. `Apt' will figure this out itself.

   Or use aptitude for a full screen interactive selection of available
   Debian packages.


CD/DVD Manufacturers
================

   You are completely free to manufacture and re-distribute CDs/DVDs of
   the Debian GNU/Linux Operating System, like this one. There is no
   charge from us (but of course donations are always welcome).

   For all needed information and contact addresses, please refer to

     http://www.debian.org/CD/


More Information
================

   There is much more information present on this disc. Besides the
   already mentioned installation and upgrading procedures, this is the
   most interesting:

     * /doc/FAQ                        Debian FAQ
     * /doc/constitution.txt           The Debian Constitution
     * /doc/debian-manifesto           The Debian Manifesto
     * /doc/social-contract.txt        Debian's Social Contract
     * /doc/bug-reporting.txt          Bug reporting instructions

   Also on the Internet are many resources. To name a few:

     * http://www.debian.org           The Debian homepage
     * http://www.debian.org/doc       Debian Documentation
     * http://www.debian.org/support   Debian User Support
     * http://www.tldp.org         The Linux Documentation Project
     * http://www.linux.org            General Linux homepage



      See the Debian contact page (http://www.debian.org/contact) for
                       information on contacting us.

                Last Modified: Sat Mar 20 12:30:45 EST 2004

References

   1. http://bugs.debian.org/
