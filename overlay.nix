prev: final: {
  emacsWithBraunsePackages = prev.emacs.pkgs.withPackages (ep: [
    ep.vterm
    ep.tsc
    ep.tree-sitter-langs
    ep.parinfer-rust-mode
  ]);
}
