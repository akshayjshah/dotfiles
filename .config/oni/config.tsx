import * as React from "react"
import * as Oni from "oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
  console.log("config activated")
}

export const deactivate = (oni: Oni.Plugin.Api) => {
  console.log("config deactivated")
}

export const configuration = {
  // https://onivim.github.io/oni-docs/#/./oni.wiki/Configuration
  "editor.fontFamily": "FiraMonoForPowerline-Regular",
  "editor.fontSize": "12px",
  "oni.useDefaultConfig": true,
  "oni.loadInitVim": true,
  "ui.colorscheme": "nova",
  "ui.animations.enabled": true,
  "ui.fontSmoothing": "auto",
}
