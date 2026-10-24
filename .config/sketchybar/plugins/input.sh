#!/usr/bin/env bash
MACISM=/opt/homebrew/bin/macism # sketchybar's PATH lacks homebrew

# click: ABC -> hiragana, anything else -> ABC
if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$("$MACISM")" = "com.apple.keylayout.ABC" ]; then
    "$MACISM" com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese
  else
    "$MACISM" com.apple.keylayout.ABC
  fi
fi

case $("$MACISM") in
  *Japanese.Katakana*) l="カ" ;;
  *Japanese*)          l="あ" ;;
  *)                   l="A"  ;; # plain ABC layout
esac
sketchybar --set "$NAME" label="$l"
