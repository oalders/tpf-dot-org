## Converting Old Pages to hugo

```shell
./bin/html-to-md.pl
```

## Viewing the Site

```shell
cd hugo
hugo serve
```

## Importing Pages From the Old Site

The pages are already in the repo, but before going live, we'll want to
re-import the latest and greatest content and then convert it to markdown.

```shell
./bin/archive-site.sh
./bin/mangle-archive.sh
```
