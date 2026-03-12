// Config docs:
//
//   https://glide-browser.app/config
//
// API reference:
//
//   https://glide-browser.app/api
//
// Default config files can be found here:
//
//   https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
//
// Most default keymappings are defined here:
//
//   https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
//
// Try typing `glide.` and see what you can do!

// Addons

const addons = [
  "https://addons.mozilla.org/firefox/downloads/file/4599707/bitwarden_password_manager-2026.1.1.xpi",
  "https://addons.mozilla.org/firefox/downloads/file/4598854/ublock_origin-1.67.0.xpi",
  "https://addons.mozilla.org/firefox/downloads/file/4614817/plasma_integration-2.1.xpi",
  "https://addons.mozilla.org/firefox/downloads/file/3849722/nord_firefox-2.41.xpi",
  "https://addons.mozilla.org/firefox/downloads/file/4625462/refined_github-25.11.22.xpi",
  "https://addons.mozilla.org/firefox/downloads/file/4357664/notifications_preview_github-24.9.23.xpi",
];

addons.forEach((url) => glide.addons.install(url));

// Commands
glide.excmds.create(
  {
    name: "open",
    description: "Navigate to a URL",
  },
  async ({ args_arr }) => {
    const tab = await glide.tabs.active();
    let openInNewTab = false;

    while (args_arr.length > 0) {
      const item = args_arr.shift()!;
      if (item === "-t") {
        openInNewTab = true;
      } else {
        break;
      }
    }

    const [url] = args_arr;

    if (openInNewTab) {
      await browser.tabs.create({ url });
    } else {
      await glide.content.execute(
        function navigate(url) {
          window.location.href = url;
        },
        { tab_id: tab.id, args: [url!] },
      );
    }
  },
);

// Preferences

//// Disable translations
glide.prefs.set("browser.translations.enable", false);

//// Disable password management (we have bitwarden)
glide.prefs.set("signon.rememberSignons", false);

//// Use old sidebar (new one limits history to 60 days)
glide.prefs.set("sidebar.revamp", false);

//// Always restore previous tabs
glide.prefs.set("browser.startup.page", 3);

//// Downloads dir
glide.prefs.set("browser.download.folderList", 2);
glide.prefs.set("browser.download.useDownloadDir", true);
glide.prefs.set("browser.download.dir", "~/Downloads");

//// Half-page scrolling
glide.prefs.set("toolkit.scrollbox.pagescroll.maxOverlapLines", 25);
glide.prefs.set("toolkit.scrollbox.pagescroll.maxOverlapPercent", 50);

//// Disable showing menu bar by pressing Alt
glide.prefs.set("ui.key.menuAccessKeyFocuses", false);

//// Compact UI
glide.prefs.set("browser.uidensity", 1);

glide.styles.add(css`
  .tab-close-button.close-icon {
    display: none;
  }
`);

// Keymaps

//// History
glide.keymaps.set("normal", "H", async () => {
  await browser.tabs.goBack();
});

glide.keymaps.set("normal", "L", async () => {
  await browser.tabs.goForward();
});

//// Tab management
glide.keymaps.del("normal", "<C-j>");
glide.keymaps.del("normal", "<C-k>");

let tab_switch_timeout: number | null = null;

async function switchTab(keys: string) {
  if (tab_switch_timeout != null) {
    clearTimeout(tab_switch_timeout);
  }

  glide.o.switch_mode_on_focus = false;
  await glide.keys.send(keys);

  tab_switch_timeout = setTimeout(() => {
    glide.o.switch_mode_on_focus = true;
  }, 250);
}

glide.keymaps.set("normal", "J", async () => {
  await switchTab("<C-S-Tab>");
});

glide.keymaps.set("normal", "K", async () => {
  await switchTab("<C-Tab>");
});

glide.keymaps.set("normal", "t", async () => {
  await glide.excmds.execute("tab_new");
});

glide.keymaps.set("normal", "x", async () => {
  await glide.excmds.execute("tab_close");
});

glide.keymaps.set("normal", "X", async () => {
  await glide.keys.send("<C-S-t>");
});

glide.keymaps.set("normal", "gt", "commandline_show tab ");

//// Opening URLs
glide.keymaps.set("normal", "o", async () => {
  await glide.keys.send("<C-l><C-a><BS>");
});

glide.keymaps.set("normal", "go", async () => {
  glide.excmds.execute(`commandline_show open ${glide.ctx.url.toString()}`);
});

glide.keymaps.set("normal", "O", async () => {
  await glide.excmds.execute("tab_new");
  await glide.keys.send("<C-l><C-a><BS>");
});

glide.keymaps.set("normal", "gO", async () => {
  glide.excmds.execute(`commandline_show open -t ${glide.ctx.url.toString()}`);
});

//// Scrolling
glide.keymaps.set("normal", "d", async () => {
  await glide.keys.send("<C-d>");
});

glide.keymaps.set("normal", "u", async () => {
  await glide.keys.send("<C-u>");
});

//// Misc actions
glide.keymaps.set("normal", "r", async () => {
  await glide.excmds.execute("reload");
});

//// Search
glide.keymaps.set("normal", "/", async () => {
  await glide.findbar.open();
});

glide.keymaps.set("insert", "<CR>", async () => {
  if (glide.findbar.is_focused()) {
    await glide.findbar.close(); // kind of a hack to just move focus out of the findbar
  } else {
    await glide.keys.send("<CR>", { skip_mappings: true });
  }
});

glide.keymaps.set("normal", "n", async () => {
  await glide.findbar.next_match();
});

glide.keymaps.set("normal", "N", async () => {
  await glide.findbar.previous_match();
});
