#! /bin/bash

cd '/opt/Empire'

if [ ! -f '/data/.bootstrap' ] ; then
  rm -f './data/empire.db' ||  { echo '[!] Unable to kill unsecure default db'; exit 1; }
  ln -sf /data/empire.db ./data/empire.db || { echo '[!] Unable to make db symlink'; exit 1; }
  ln -sf /data/empire-chain.pem ./data/empire-chain.pem
  ln -sf /data/empire-priv.key ./data/empire-priv.key
  STAGING_KEY=RANDOM python './setup/setup_database.py' || { echo '[!] Unable to generate a new db'; exit 1; }
  { cd ./setup; ./cert.sh || { echo '[!] Unable to setup self signed certs'; exit 1; }; cd ../; }
  mkdir /data/downloads
  ln -s /data/downloads
  touch /data/.bootstrap
  args='--resource /opt/Empire/profile.rc'
fi

exec -a empire python ./empire ${args}
