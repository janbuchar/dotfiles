import os
import platformdirs
from pathlib import Path
from typing import Any

config: Any = config

config.load_autoconfig(False)

QUTE_RBW = f'/usr/bin/pipx run {os.environ["HOME"]}/.local/share/qutebrowser/userscripts/qute-rbw'

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
config.bind('pw', f'spawn --userscript {QUTE_RBW}')
config.bind('m', 'spawn vlc {url}')
config.bind('M', 'hint links spawn vlc {hint-url}')
config.bind('<Ctrl-r>', 'reload')

config.set('auto_save.session', True)
config.set(
    'downloads.location.directory', 
    os.path.expanduser("~/Downloads") 
    if os.path.exists(os.path.expanduser("~/Downloads"))
    else platformdirs.user_downloads_dir()
)

config.set('content.register_protocol_handler', False)
config.set('content.javascript.clipboard', 'access-paste')
config.set('content.notifications.enabled', False)
config.set('content.local_content_can_access_remote_urls', True)

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
}

config.set('colors.statusbar.normal.bg', palette['nord1'])
config.set('colors.statusbar.normal.fg', palette['nord6'])
config.set('colors.statusbar.insert.bg', palette['nord14'])
config.set('colors.statusbar.insert.fg', palette['nord0'])
config.set('colors.statusbar.url.success.http.fg', palette['nord6'])
config.set('colors.statusbar.url.success.https.fg', palette['nord14'])
config.set('colors.statusbar.command.fg', palette['nord5'])
config.set('colors.statusbar.command.bg', palette['nord2'])

config.set('colors.tabs.even.fg', palette['nord6'])
config.set('colors.tabs.odd.fg', palette['nord6'])
config.set('colors.tabs.even.bg', palette['nord0'])
config.set('colors.tabs.odd.bg', palette['nord2'])
config.set('colors.tabs.selected.even.bg', palette['nord8'])
config.set('colors.tabs.selected.odd.bg', palette['nord8'])
config.set('colors.tabs.selected.even.fg', palette['nord0'])
config.set('colors.tabs.selected.odd.fg', palette['nord0'])

config.set('colors.downloads.bar.bg', palette['nord0'])
config.set('colors.downloads.stop.bg', palette['nord14'])
config.set('colors.downloads.stop.fg', palette['nord0'])
config.set('colors.downloads.start.bg', palette['nord6'])
config.set('colors.downloads.start.fg', palette['nord0'])

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
config.set('colors.completion.scrollbar.fg', palette['nord8'])
config.set('colors.completion.scrollbar.bg', palette['nord1'])

user_css_path = Path(__file__).parent / "user.css"
user_css_path.write_text(f"""
::-webkit-scrollbar {{
  width: 10px;
  height: 8px;
}}
::-webkit-scrollbar-track:vertical {{
  background: {palette['nord2']};
}}

::-webkit-scrollbar-thumb:vertical {{
  background: {palette['nord8']};
}}
::-webkit-scrollbar-thumb:vertical:hover {{
  background: {palette['nord6']};
}}

::-webkit-scrollbar-track:horizontal {{
  background: {palette['nord2']};
}}

::-webkit-scrollbar-thumb:horizontal {{
  background: {palette['nord8']};
}}
::-webkit-scrollbar-thumb:horizontal:hover {{
  background: {palette['nord6']};
}}

::-webkit-scrollbar-corner {{
  background: {palette['nord0']};
}}
""")

config.set('content.user_stylesheets', [str(user_css_path)])

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

config.set('content.blocking.whitelist', [
    'https://online.mbank.cz'
])

config.set('qt.args', ['disable-accelerated-2d-canvas'])
