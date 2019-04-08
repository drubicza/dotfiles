#---------------------------------------------------------------------------------------------------
# Klavoj
#---------------------------------------------------------------------------------------------------

config.unbind("q")
config.unbind("ad")
config.unbind("[[")
config.unbind("]]")
config.unbind("<Ctrl+PgUp>")
config.unbind("<Ctrl+PgDown>")

config.bind("a", 'open -t')
config.bind ("@", 'config-cycle content.user_stylesheets ~/.config/qutebrowser/css/emem.css ""')
config.bind(",t", 'open -t http://tujavortaro.net')
config.bind(",r", 'open -t http://www.reta-vortaro.de/revo/')
config.bind(",l", 'open -t https://limnu.com/d/user.html')
config.bind("[", 'navigate prev')
config.bind("]", 'navigate next')
