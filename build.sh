#! /bin/bash

rm -r _site
rm -r docs
bundle exec jekyll build
mv _site docs
rm docs/build.sh

echo "Update docs for gh-pages to `git rev-parse HEAD`" > .gh-pages-update
git add docs/
git commit --file=.gh-pages-update
rm .gh-pages-update

echo "Done. Now push it!"
