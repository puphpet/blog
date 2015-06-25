#!/usr/bin/env bash

sculpin generate --env=prod
rsync -Oavze 'ssh -p 22' output_prod/ puphpet.com:/var/www/blog.puphpet.com/public_html
