#!/bin/sh
cat > .git/hooks/post-checkout << EOF 
#!/bin/sh
xcodegen generate --use-cache --spec Project.yml
EOF

cp .git/hooks/post-checkout .git/hooks/post-merge

chmod +x .git/hooks/post-checkout
chmod +x .git/hooks/post-merge

xcodegen generate --spec Project.yml
