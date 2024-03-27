# Add Utils path
export PATH=$PATH:$HOME/Util:$HOME/.local/bin

# Set web browser
export BROWSER=$( which qb-open )

# Set editor
export EDITOR=$( which nvim )

# Set Java options (font anti-aliasing, L&F)
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd_hrgb -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

# Set SSH agent socket
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
