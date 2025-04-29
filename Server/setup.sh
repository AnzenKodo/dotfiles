sudo apt install rsync git

rsync -avP --hard-links --archive --recursive --update --executability --human-readable --progress --exclude='/.git' --filter="dir-merge,- .gitignore" ~/Code

