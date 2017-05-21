
I use this shard to sanitize URI/URLs for `src` and `href` HTML attributes.

However, if you know of another URI/URL sanitization shard to be used for
`src` and `href` attributes, please let me know in the "Issues" section
so I can tell others about it.

You don't want to use this SHARD because it's too specific for my needs.
It's very strict and only allows `http`, `https`, `ftp`, `sftp`.
No `mailto` or other schemes. So it's basically useless for most people
unless they share my views on paranoid security.


Specs for this shard was inspired by:
  * https://github.com/jarrett/sanitize-url/tree/master/spec
