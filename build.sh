set -e
npm run build
cd dist
git init
git remote add origin https://github.com/Goddywu/conversation-bot.git
git add .
git commit -m 'init'
git push --force -u origin master 
cd -
git add .
git commit -m 'init'
git push