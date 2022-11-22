prev: final: {
  emacsWithBraunsePackages = prev.emacs.pkgs.withPackages (ep: [
    ep.vterm
  ]);
}
