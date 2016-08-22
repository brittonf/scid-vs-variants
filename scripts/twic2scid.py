#!/usr/bin/env python

# Download the current week's TWIC games and append them to an existing
# Scid database and perform spellchecking.

# Usage: twic2scid.py [Options] [database [spellingfile]]

# Options:
#   -h, --help  show this help message and exit
#   -a, --all   gets all pgn archives on the page. Overrides -n if specified.
#   -n LATESTN  gets LATESTN archives. LATESTN must be an integer. If LATESTN is
#               greater than the number of pgn archives found on the twic page,
#               this is equivalent to --all. If LATESTN is zero, this option is
#               ignored.
#   -d DATABASE, --database=DATABASE
#               specify the scid database to merge into. Default value
#               is 'twic'. Note that this omits the extension .si4 of
#               the database.
#   -s SPELLING, --spelling=SPELLING
#               specifies the spelling file for meta corrections.
#               Default value is 'spelling.ssp'.

# Example usage:
#   twic2scid.py -n 3 -d ~/scidbases/twic -s ~/scidbases/spelling.ssp
#     --merges latest 3 pgns into specified scid database and spelling file.
#   twic2scid.py -a
#     --merges all pgns available into the default database with the default spelling file.
#   twic2scid.py --latestn=5 --spelling=another_spelling.ssp
#     --merges latest 5 pgns into the default database 'twic.si4' in current directory, and uses spelling file 'another_spelling.ssp' in current directory.


# If no database/spellingfile args are given, these defaults are used
# (note - database does not include ".si4")

# scid_database = "twic"
# scid_spelling = "spelling.ssp"

# This version fixes a few bugs, and will use lftp if you have it
# installed, wget if not.  If neither of those work, it will attempt to
# download the URL directly, using Python's urllib.py module (which
# doesn't do regetting, retrying, etc).

# By John Wiegley

# Modifications by Maksim Grinman:
# 3/20/2013: Updated to work with the new TWIC site at http://www.theweekinchess.com/twic
# 3/23/2013: Updated to support optional flags -a and -n.

# NOTE: This program comes with absolutely NO WARRANTY.  If anything
# goes wrong, it may delete your database entirely instead of adding
# to it!  I recommend backing up your database, trying it out, and
# then adding a "last week rollback" type of copy command to your
# cronjob, just to make sure.


import glob
import urllib
import zipfile
import tempfile
import string
import sys
import re
import os

from optparse import OptionParser

os.environ['PATH'] = os.environ['PATH'] + ":/usr/local/bin"

usage = "Usage: %prog [Options]\n\n" \
  "twic2scid.py --help to see options.\n\n" \
  "Example usage:\n" \
  "  twic2scid.py -n 3 -d ~/scidbases/twic -s ~/scidbases/spelling.ssp\n" \
  "    --merges latest 3 pgns into specified scid database and spelling file.\n" \
  "  twic2scid.py -a\n" \
  "    --merges all pgns available into the default database with the default spelling file.\n" \
  "  twic2scid.py --latestn=5 --spelling=another_spelling.ssp\n" \
  "    --merges latest 5 pgns into the default database 'twic.si4' in current directory, and uses " \
  "spelling file 'another_spelling.ssp' in current directory."
  
parser = OptionParser(usage)

parser.add_option("-a", "--all", action="store_true", dest="all",
                  help="gets all pgn archives on the page. Overrides -n if specified.")

parser.add_option("-n", "--latestn", type="int", dest="latestn",
                  help="gets LATESTN archives. LATESTN must be an integer. If LATESTN is greater than the number of pgn archives found on the twic page, this is equivalent to --all. If LATESTN is zero, this option is ignored.")

parser.add_option("-d", "--database", dest="database",
                  help="specify the scid database to merge into. Default value is 'twic'. Note that this omits the extension .si4 of the database.")

parser.add_option("-s", "--spelling", dest="spelling",
                  help="specifies the spelling file for meta corrections. Default value is 'spelling.ssp'.")


# DEFAULTS are set here
parser.set_defaults(database="twic",
                    spelling="spelling.ssp")

(options, args) = parser.parse_args()

if options.all or options.latestn == 0 or options.latestn == None:
    options.latestn = None
else:
    options.latestn = abs(options.latestn)

scid_database = options.database
scid_spelling = options.spelling

print "Downloading the Week in Chess main page..."

url = urllib.urlopen("http://www.theweekinchess.com/twic")

# list of pgn links found
pgn_links = []
    
found = 0
for line in url.readlines():
    match = re.search("http://[^\"]+", line)
    if match:
        pgn = re.search(">PGN<", line)
        if pgn:
            pgn_links.append(match.group(0))
            found = found + 1
            if options.all:
                continue
            elif options.latestn and found != options.latestn:
                continue
            else:
                break

if not found:
    print "Could not find PGN zipfile name in twic.html!"
    sys.exit(1)

# I prefer to use lftp here, since it does all the retrying and status
# display for me

print "Getting PGN archives \"%s\"..." % pgn_links

# will hold scid databases to be merged
databases = []
    
# will hold zips downloaded, each zip should contain a pgn file
pgn_zips = []
    
# containers = will hold pointer to each 'container' for cleanup after use
containers = []
    
for link in pgn_links:
    container = tempfile.mktemp(".zip")
    containers.append(container)
    
    if os.path.isfile("/usr/bin/lftp"):
        status = os.system("lftp -c 'get %s -o %s; quit'" % (link, container))
    else:
        status = os.system("wget -O %s %s" % (container, link))
        
        if status != 0:
            print "lftp or wget not working, retrying directly..."
            fd = open(container, "wb")
            fd.write(urllib.urlretrieve(link))
            fd.close()

    pgn_zips.append(zipfile.ZipFile(container))

print "Unzipping and converting to scid databases..."

for pgn_zip in pgn_zips:
    for file in pgn_zip.namelist():
        if re.search("\.pgn$", file):
            output = tempfile.mktemp(".pgn")
            outfd = open(output, "wb")
            outfd.write(pgn_zip.read(file))
            outfd.close()
            
            database = tempfile.mktemp()
            os.system("pgnscid -f %s %s" % (output, database))
            databases.append(database)
            
            os.unlink(output)    
    pgn_zip.close()

map(os.unlink, containers)

print "Merging databases into %s.new..." % scid_database

if databases:
    status = os.system("scmerge %s %s %s" %
                       (scid_database + ".new",
                        scid_database, string.join(databases, " ")))

    for file in databases:
        map(os.unlink, glob.glob("%s.s*" % file))

    if status == 0:
        print "Moving new database to %s..." % scid_database
        map(os.unlink, glob.glob("%s.s*" % scid_database))
        os.system("scmerge %s %s" % (scid_database, scid_database + ".new"))
        map(os.unlink, glob.glob("%s.s*" % (scid_database + ".new")))
        print "Spell checking the new database..."
        os.system("sc_spell %s %s" % (scid_database, scid_spelling))
