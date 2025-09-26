#!/usr/bin/env bash

git submodule update --init --remote wiki

cp "wiki/Contribute.md" docs/_includes/contribute.external.md
cp "wiki/Projects.md" docs/_includes/projects.external.md
