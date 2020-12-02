rm -f site.zip
(cd sites/express && npm install)
(cd sites/express && zip -r ../../site.zip node_modules src)
