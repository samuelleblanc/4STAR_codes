find . -mindepth 2 -type f ! -path './data_folder/*' ! -path './.git/*' -exec mv {} . \;
