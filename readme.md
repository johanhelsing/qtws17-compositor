# qtws17-compositor

This is the compositor I used for my Qt Wayland Compositor live-coding session
at Qt World Summit 2017:

https://www.youtube.com/watch?v=mIg1P3i2ZfI

The presentation is written to run nested compositors and a text editor inside
slides. The goal is to enable easy live coding and good syntax highlighting.

## Requirements

- Qt dev branch (or 5.11 or newer when that's released)
- Qt Wayland Compositor (also dev or 5.11)

I used `nvim-qt` as my editor and `konsole` as my terminal, but that should be
easily interchangeable.

There's a couple of hard-coded paths to places on my fs, but it should be
fixable.

## Contact

If you have problems or questions, don't hesitate to contact me on
`#qt-lighthouse` on freenode.
