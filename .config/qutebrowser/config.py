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
config.bind('m', 'spawn vlc {url}')
config.bind('M', 'hint links spawn vlc {hint-url}')

config.set('auto_save.session', True)
config.set('downloads.location.directory', os.path.expanduser("~/Downloads"))

config.set('tabs.padding', {"top": 3, "bottom": 4, "left": 5, "right": 5})
config.set('tabs.indicator.width', 0)
config.set('scrolling.bar', 'always')
config.set('statusbar.padding', {"top": 3, "bottom": 2, "left": 0, "right": 0})
config.set('statusbar.widgets', ["keypress", "url", "progress"])
config.set('fonts.tabs.selected', '10pt "Liberation Sans"')
config.set('fonts.tabs.unselected', '10pt "Liberation Sans"')
config.set('fonts.statusbar', '10pt "Liberation Sans"')
config.set('fonts.completion.category', 'default_size "Liberation Sans"')
config.set('fonts.completion.entry', 'default_size "Liberation Sans"')

config.set("fonts.default_family", ["Liberation Mono", "DejaVu Sans Mono", "monospace"])

palette = {
    # Polar Night
    'nord0': '#2e3440',
    'nord1': '#3b4252',
    'nord2': '#434c5e',
    'nord3': '#4c566a',
    # Snow Storm
    'nord4': '#d8dee9',
    'nord5': '#e5e9f0',
    'nord6': '#eceff4',
    # Frost
    'nord7': '#8fbcbb',
    'nord8': '#88c0d0',
    'nord9': '#81a1c1',
    'nord10': '#5e81ac',
    # Aurora
    'nord11': '#bf616a',
    'nord12': '#d08770',
    'nord13': '#ebcb8b',
    'nord14': '#a3be8c',
    'nord15': '#b48ead',
    # Papirus Background
    'papirus0': '#eff0f1',
    'papirus1': '#e3e5e7',
    # Papirus Foreground
    'papirus2': '#000000',
    'papirus3': '#31363b',
    'papirus4': '#888888',
    # Papirus Green
    'papirus5': '#27ae60'
}

config.set('colors.statusbar.normal.bg', palette['papirus0'])
config.set('colors.statusbar.normal.fg', palette['papirus2'])
config.set('colors.statusbar.insert.bg', palette['papirus5'])
config.set('colors.statusbar.insert.fg', palette['papirus2'])
config.set('colors.statusbar.url.success.http.fg', palette['papirus2'])
config.set('colors.statusbar.url.success.https.fg', palette['papirus5'])
config.set('colors.statusbar.command.fg', palette['nord5'])
config.set('colors.statusbar.command.bg', palette['nord2'])

config.set('colors.tabs.even.fg', palette['papirus3'])
config.set('colors.tabs.odd.fg', palette['papirus3'])
config.set('colors.tabs.even.bg', palette['papirus1'])
config.set('colors.tabs.odd.bg', palette['papirus0'])
config.set('colors.tabs.selected.odd.bg', palette['papirus4'])
config.set('colors.tabs.selected.even.bg', palette['papirus4'])
config.set('colors.tabs.selected.odd.fg', '#fff')
config.set('colors.tabs.selected.even.fg', '#fff')

config.set('colors.downloads.bar.bg', palette['papirus0'])
config.set('colors.downloads.stop.bg', palette['papirus5'])
config.set('colors.downloads.stop.fg', '#fff')
config.set('colors.downloads.start.bg', palette['papirus4'])
config.set('colors.downloads.start.fg', '#fff')

config.set('colors.prompts.bg', palette['nord2'])
config.set('colors.prompts.fg', palette['nord5'])
config.set('colors.prompts.border', f"1 px solid {palette['nord5']}")

config.set('colors.completion.category.bg', palette['nord0'])
config.set('colors.completion.category.fg', palette['nord5'])
config.set('colors.completion.category.border.bottom', palette['nord0'])
config.set('colors.completion.category.border.top', palette['nord0'])
config.set('colors.completion.even.bg', palette['nord1'])
config.set('colors.completion.odd.bg', palette['nord1'])
config.set('colors.completion.fg', palette['nord4'])
config.set('colors.completion.item.selected.bg', palette['nord3'])
config.set('colors.completion.item.selected.fg', palette['nord6'])
config.set('colors.completion.item.selected.border.bottom', palette['nord3'])
config.set('colors.completion.item.selected.border.top', palette['nord3'])
config.set('colors.completion.match.fg', palette['nord13'])
config.set('colors.completion.scrollbar.fg', palette['nord5'])
config.set('colors.completion.scrollbar.bg', palette['nord1'])

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
    'mapy': 'https://mapy.cz/zakladni?q={}',
    'mdn': 'https://developer.mozilla.org/en-US/search?q={}',
    'cpp': 'https://en.cppreference.com/mwiki/index.php?search={}',
    'py': 'https://docs.python.org/3/search.html?q={}',
})
