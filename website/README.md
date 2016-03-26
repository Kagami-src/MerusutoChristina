Sample Application built with Backbone.js and Ratchet 2.0
===
[Online Demo](http://bbtfr.github.io/backbone-ratchet)

Dependency
---
* middleman
* [middleman-bower](https://github.com/bbtfr/middleman-bower)
* middleman-deploy
* underscore
* backbone
* zepto
* ratchet

Setup
---
```bash
# Initialize
git clone https://github.com/bbtfr/backbone-ratchet.git your-project-folder
cd your-project-folder
git remote rm origin
git remote add origin your-git-url

# Setup
bundle install
middleman bower install

# Start the server
middleman 
```
