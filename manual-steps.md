# manual steps
Miscellaneous list of things not yet handled in an automated way.

### cinnamon highdpi switch
needs to not be in main conf:

```aconf
[cinnamon]
active-display-scale=2

[cinnamon/desktop/interface]
scaling-factor=uint32 2

[gnome/desktop/interface]
scaling-factor=uint32 2
```

### cinnamon annoying file open search not using names
- cinnamon searching history when browsing files with open... change in behaviour... doesn't appear to be a thing anymore.. what changed?
maybe this:

```aconf
[gtk/settings/file-chooser]
sort-column='name'
show-hidden=true
sort-directories-first=false
location-mode='path-bar'
```

### dark theme
now an option somewhere in system settings. no dconf entry for it...

## gitconfig
update `diff-highlight` when we got 2.9

## Sublime
Some manual steps required.

- [license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- [package control](https://packagecontrol.io/installation)