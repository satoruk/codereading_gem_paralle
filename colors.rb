module Colors
  IGNORE_COLORS = %i(
    aliceblue      antiquewhite   azure         beige      bisque
    black          blanchedalmond cadetblue     cornsilk   darkblue
    darkolivegreen darkslateblue  darkslategray dimgray    floralwhite
    floralwhite    gainsboro      ghostwhite    honeydew   indigo
    ivory          lavender       lavenderblush lightcyan  lightgoldenrod
    lightslategray lightyellow    linen         mediumblue midnightblue
    mintcream      mistyrose      navyblue      oldlace    papayawhip
    peachpuff      powderblue     seashell      silver     slategray
    snow           webgray        webmaroon     webpurple  wheat
    white          whitesmoke
  )
  COLORS = Rainbow::X11ColorNames::NAMES.keys.delete_if do |v|
    IGNORE_COLORS.include? v
  end.sort
  SEVERITY_COLORS = {
    'DEBUG' => :webgray,
    'ERROR' => :red,
    'FATAL' => :red,
    'INFO' => :lightslategray,
    'UNKNOWN' => :webgray,
    'WARN' => :red,
  }

  COLORIZE_LOG_FORMATTER = proc do |severity, datetime, progname, msg|
    pid = Process.pid
    tid = Thread.current.object_id
    "%s pid:%s tid:%s [%s] %s\n" % [
      datetime,
      sprintf('%-7d',       pid).background(:black).foreground(COLORS[pid % COLORS.size]),
      sprintf('%-15d',      tid).background(:black).foreground(COLORS[tid % COLORS.size]),
      sprintf('%-5s',  severity).background(:black).foreground(SEVERITY_COLORS[severity]),
      msg,
    ]
  end
end
