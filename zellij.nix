{ pkgs, ... }:
{
  text = ''
    keybinds {
      shared_except "locked" {
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        bind "Alt 3" { GoToTab 3; }
        bind "Alt 4" { GoToTab 4; }
        bind "Alt 5" { GoToTab 5; }
        bind "Alt 6" { GoToTab 6; }
        bind "Alt 7" { GoToTab 7; }
        bind "Alt 8" { GoToTab 8; }
        bind "Alt 9" { GoToTab 9; }
      }
    }

    layout {
      default_tab_template {
        pane size=1 borderless=true {
          plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
            format_left   "{mode} #[fg=#d4be98,bold]"
            format_center "{tabs}"
            mode_normal        ""
            mode_tmux          "#[bg=#d8a657,fg=#282828] {name}"
            mode_locked        "#[fg=#ea6962,bold]{name}"
            mode_resize        "#[fg=#d8a657,bold]{name}"
            mode_pane          "#[fg=#d3869b,bold]{name}"
            mode_tab           "#[fg=#7daea3,bold]{name}"
            mode_scroll        "#[fg=#a9b665,bold]{name}"
            mode_session       "#[fg=#e78a4e,bold]{name}"
            mode_move          "#[fg=#a89984,bold]{name}"
            hide_frame_for_single_pane "true"
            tab_normal         "#[fg=#504945]  {index}  "
            tab_active         "#[fg=#d4be98,bold,italic]  {index}  "
          }
        }
        children
      }
      
      tab name="neovim" focus=true {
        pane {
          command "nvim"
        }
      }
      
      tab name="terminal" {
        pane
      }
      
      tab name="lazygit" {
        pane {
          command "lazygit"
        }
      }
    }
  '';

}
