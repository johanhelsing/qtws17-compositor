# qtws17-compositor

This is the compositor I used for my Qt Wayland Compositor live-coding session
at Qt World Summit 2017:

https://www.youtube.com/watch?v=mIg1P3i2ZfI

The presentation is written to run nested compositors and a text editor inside
slides. The goal is to enable easy live coding and good syntax highlighting.

## Requirements

- Qt 5.11 or newer
- Qt Wayland Compositor module

I used `nvim-qt` as my editor and `konsole` as my terminal, but that should be
easily interchangeable.

There's a couple of hard-coded paths to places on my fs, but it should be
fixable.

## Contact

If you have problems or questions, try asking on `#qt-lighthouse` on freenode.
Or post an issue on this project.
