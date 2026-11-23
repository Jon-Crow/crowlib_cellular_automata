You must have a built version of SDL in order to run testbenches that use the sim_display plugin.
Example: "make plugins SDL_PATH=[path to your SDL install]"

Note that all Makefiles are currently written to run on Windows.

To run this module's simulation:
- Navigate to sim directory
- make plugins (only need to run one time)
- make compile
- make sim
- make view (to view waveform. Must have gtkwave installed.)