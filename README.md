# Instructions
1. `build.sh`, to build the Docker image.
2. `docker run pythonnet-ex`.  This will run `main.py` script, which invokes the problematic `clr.addReference`.  The output should be similar to what's in the `pythonnet_crashlog` file.
