self: super: {
  chromium = super.chromium.override {
    enablePepperFlash = true;
  };
}
