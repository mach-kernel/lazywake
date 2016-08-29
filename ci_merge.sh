[[ `git log -1 --oneline --pretty=%B` =~ ^wip$ ]] && exit 1
git config --global user.email "dstancu+lazywake_dev@nyu.edu"
git config --global user.name "CircleCI (dstancu)"
git checkout master && git merge - --no-ff --no-edit && git push