self: super: {
  emacs = super.emacs.override {
    withGTK2 = false;
    withGTK3 = false;
    withXwidgets = false;
  };
}
