#!/usr/bin/env bash
floating=$(paneru query state | jq -r '
  .active.focused_window_id as $fid
  | ([.virtual_workspaces[].windows[] | select(.window_id == $fid) | .floating] | first) // false')
[ "$floating" = "true" ] && paneru send-cmd window focus managed \
                          || paneru send-cmd window focus unmanaged
sketchybar --trigger paneru_manage_change
