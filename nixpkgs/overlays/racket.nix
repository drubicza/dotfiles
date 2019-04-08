self: super: {
  racket = super.racket.override {
    disableDocs = false;
  };
}
