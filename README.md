# cert-renewer
 Issue and renew the cert by acme.sh docker with cloudflare on Synology

# Usage
1. Login DSM and open Docker on Synology
2. Download latest [neilpang/acme.sh](https://registry.hub.docker.com/r/neilpang/acme.sh/) images
3. Follow [this page](https://www.xfelix.com/2020/04/issue-synology-lets-encrypt-cert-by-acme-sh-docker/) to create account.conf from cloudflare token and issue cert by this container (Using root account)
4. Schedule task to run this script to renew cert
    <pre><code>/path/to/task/cert-renewer/renew_cert.sh</code></pre>
