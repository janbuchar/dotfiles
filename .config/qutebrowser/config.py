import os

config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')
config.bind('-', 'set-cmd-text /')
config.bind('x', 'tab-close')
config.bind('X', 'undo')
config.bind('t', 'open -t')
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind(']', 'navigate next')
config.bind('[', 'navigate prev')
config.bind('pw', 'spawn --userscript pass autofill')
config.bind('pu', 'spawn --userscript pass update')
config.bind('m', 'spawn vlc {url}')
config.bind('M', 'hint links spawn vlc {hint-url}')

config.set('auto_save.session', True)
config.set('downloads.location.directory', os.path.expanduser("~/Downloads"))

config.set('tabs.padding', {"top": 3, "bottom": 4, "left": 5, "right": 5})
config.set('tabs.indicator.width', 0)
config.set('scrolling.bar', 'always')
config.set('statusbar.padding', {"top": 3, "bottom": 2, "left": 0, "right": 0})
config.set('statusbar.widgets', ["keypress", "url", "progress"])
config.set('fonts.tabs', '10pt "Liberation Sans"')
config.set('fonts.statusbar', '10pt "Liberation Sans"')

config.set("fonts.monospace", "Liberation Mono, DejaVu Sans Mono, monospace")

config.set('colors.statusbar.normal.bg', '#eff0f1')
config.set('colors.statusbar.normal.fg', '#000')
config.set('colors.statusbar.insert.bg', '#27ae60')
config.set('colors.statusbar.insert.fg', '#000')
config.set('colors.statusbar.url.success.http.fg', '#000')
config.set('colors.statusbar.url.success.https.fg', '#27ae60')

config.set('colors.tabs.even.fg', '#31363b')
config.set('colors.tabs.odd.fg', '#31363b')
config.set('colors.tabs.even.bg', '#e3e5e7')
config.set('colors.tabs.odd.bg', '#eff0f1')
config.set('colors.tabs.selected.odd.bg', '#888')
config.set('colors.tabs.selected.even.bg', '#888')
config.set('colors.tabs.selected.odd.fg', '#fff')
config.set('colors.tabs.selected.even.fg', '#fff')

config.set('url.searchengines', {
    'DEFAULT': 'https://www.google.com/search?q={}',
    'google': 'https://www.google.com/search?q={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'yt': 'http://www.youtube.com/results?search_query={}',
    'wp': 'http://www.wikipedia.org/search-redirect.php?family=wikipedia&search={}&language=en&go=Go',
    'wpcs': 'http://www.wikipedia.org/search-redirect.php?family=wikipedia&search={}&language=cs&go=Go',
    'aw': 'https://wiki.archlinux.org/index.php?title=Special:Search&search={}',
    'gh': 'https://github.com/search?utf8=✓&q={}',
    'r': 'https://reddit.com/r/{}',
    'aur': 'https://aur.archlinux.org/packages/?O=0&K={}',
    'mapy': 'https://mapy.cz/zakladni?q={}'

})
